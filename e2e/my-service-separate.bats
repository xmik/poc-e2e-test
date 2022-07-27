load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'


@test "cleanup before my-service runs in a docker container" {
  run /bin/bash -c "docker stop my-service || true"
  assert_equal "$status" 0
  run /bin/bash -c "docker rm my-service || true"
  assert_equal "$status" 0
}
@test "my-service runs fine in a docker container" {
  run /bin/bash -c "docker run -d -p 80:80 -v ${PWD}/e2e/index.html:/usr/local/apache2/htdocs/index.html --name=my-service httpd:alpine3.16"
  refute_output --partial "error"
  refute_output --partial "ERROR"
  assert_equal "$status" 0

  sleep 2
  run /bin/bash -c "docker logs my-service"
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Apache/2.4.54"
  refute_output --partial "error"
  refute_output --partial "ERROR"
  assert_equal "$status" 0

  run /bin/bash -c "curl localhost:80"
  assert_line --partial "My custom text"
  refute_output --partial "It works"
  assert_equal "$status" 0
}
@test "cleanup after my-service runs in a docker container" {
  run /bin/bash -c "docker stop my-service || true"
  assert_equal "$status" 0
  run /bin/bash -c "docker rm my-service || true"
  assert_equal "$status" 0
}
