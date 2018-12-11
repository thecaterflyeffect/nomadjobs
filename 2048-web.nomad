job "2048-web" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "web" {
    count = 2
    constraint {
      distinct_hosts = true
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "2048-web-game" {
      driver = "docker"

      config {
        image = "thecaterflyeffect/docker-2048"
        
        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = 8080
          }
        }
      }

      service {
        name = "2048-web-game"
        tags = ["urlprefix-/"]

        port = "http"

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/"
        }
      }
    }
  }
}
