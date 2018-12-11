job "check-in-batch" {
  datacenters = ["dc1"]

  type = "batch"

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  periodic {
    // Launch every 30 seconds
    cron = "*/30 * * * * * *"

    // Do not allow overlapping runs.
    prohibit_overlap = true
  }

  group "check-in-batch" {
    count = 3

    task "check-in" {
      driver = "exec"

      config {
        command = "/usr/bin/logger"
        args    = ["NOMAD batch job checked in on", "${node.unique.name}", "${NOMAD_ALLOC_NAME}"]

      }
    }
  }
}
