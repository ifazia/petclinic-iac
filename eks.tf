locals {
  cluster_name = "petclinic-eks"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.12.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = null

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }
}

module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "petclinic_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  depends_on = [
    module.eks
  ]
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }

  depends_on = [
    module.lb_role
  ]
}

resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "region"
    value = "eu-west-3"
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = local.cluster_name
  }

  depends_on = [
    kubernetes_service_account.service-account
  ]
}

resource "helm_release" "kube-prometheus-stack" {
  name             = "prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  # Configuration de Grafana
  set {
    name  = "grafana.adminPassword"
    value = var.GRAFANA_PASSWORD
  }

  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }

  set {
    name  = "grafana.ingress.ingressClassName"
    value = "alb"
  }

  set {
    name  = "grafana.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internet-facing"
  }

  set {
    name  = "grafana.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  }

  # Configuration pour Prometheus
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "1d"  # Définit la rétention à 1 jour et à ajuster selon le besoin
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "2Gi" # à ajuster selon le besoin
  }

  # Déployer les règles d'alerte via un ConfigMap
  set {
    name  = "prometheus.prometheusSpec.additionalPrometheusRules"
    value = yamlencode({
      groups = [
        {
          name = "petclinic-alerts"
          rules = [
            {
              alert = "HighCPUUsage"
              expr  = "sum(rate(container_cpu_usage_seconds_total{container!=\"\",pod!=\"\"}[5m])) by (pod) / sum(container_spec_cpu_quota{container!=\"\",pod!=\"\"}) by (pod) > 0.9"
              for   = "5m"
              labels = {
                severity = "critical"
              }
              annotations = {
                summary     = "Le pod {{ $labels.pod }} utilise plus de 90% de CPU."
                description = "L'utilisation de la CPU est trop élevée pendant plus de 5 minutes."
              }
            },
            {
              alert = "HighMemoryUsage"
              expr  = "sum(container_memory_usage_bytes{container!=\"\",pod!=\"\"}) by (pod) / sum(container_spec_memory_limit_bytes{container!=\"\",pod!=\"\"}) by (pod) > 0.9"
              for   = "5m"
              labels = {
                severity = "critical"
              }
              annotations = {
                summary     = "Le pod {{ $labels.pod }} utilise plus de 90% de mémoire."
                description = "L'utilisation de la mémoire est trop élevée pendant plus de 5 minutes."
              }
            },
            {
              alert = "HighHTTPErrorRate"
              expr  = "sum(rate(http_requests_total{status=\"500\", job=\"spring-petclinic\"}[5m])) by (status) > 0.1"
              for   = "5m"
              labels = {
                severity = "critical"
              }
              annotations = {
                summary     = "Erreur HTTP 500 trop fréquente"
                description = "Le taux d'erreurs HTTP 500 a dépassé le seuil pendant plus de 5 minutes."
              }
            },
            {
              alert = "HighNetworkUsage"
              expr  = "sum(rate(node_network_receive_bytes_total[5m])) by (instance) > 1000000000"
              for   = "5m"
              labels = {
                severity = "critical"
              }
              annotations = {
                summary     = "Utilisation du réseau trop élevée sur {{ $labels.instance }}."
                description = "L'utilisation du réseau a dépassé 1 Go/s pendant plus de 5 minutes."
              }
            }
          ]
        }
      ]
    })
  }

  depends_on = [
    kubernetes_service_account.service-account,
    helm_release.alb-controller,
    module.vpc
  ]
}