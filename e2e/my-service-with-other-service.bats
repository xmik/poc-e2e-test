load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'


@test "cleanup before my-service runs with the other service" {
  run /bin/bash -c "docker-compose -f e2e/docker-compose.yaml down || true"
  assert_equal "$status" 0
}
@test "my-service runs fine in a docker container" {
  run /bin/bash -c "docker-compose -f e2e/docker-compose.yaml up -d"
  refute_output --partial "error"
  refute_output --partial "ERROR"
  assert_equal "$status" 0

  sleep 2
  run /bin/bash -c "docker logs e2e_my_service_1"
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

  run /bin/bash -c "docker exec -ti e2e_other_service_1 sh -c 'curl my_service:80'"
  assert_line --partial "My custom text"
  refute_output --partial "It works"
  assert_equal "$status" 0
}
@test "cleanup after my-service runs with the other service" {
  run /bin/bash -c "docker-compose -f e2e/docker-compose.yaml down || true"
  assert_equal "$status" 0
}
