[
  {
    "name": "community-day",
    "image": "${image}",
    "memory": ${memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0
      }
    ],
    "mountPoints": [
      {
        "containerPath": "/var/www/html",
        "sourceVolume": "${efs_website_commons}",
        "readOnly": true
      },
      {
        "containerPath": "/var/www/blog",
        "sourceVolume": "${efs_blog}",
        "readOnly": true
      }
    ]
  }
]