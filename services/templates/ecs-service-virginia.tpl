[
  {
    "name": "community-day",
    "image": "${image}",
    "memory": ${memory},
    "essential": true,
    "privileged": true,
    "command": [
        "sh",
        "-c",
        "/var/www/virginia-mount-efs.sh; nginx -s reload & nginx -g 'daemon off;'"
      ],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0
      }
    ]
  }
]