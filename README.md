# poc-e2e-test

This is a small Proof of Concept of example tests for Docker images.

## Prerequisites
* Docker
* Docker-compose
* Bats-core

Bats-core can be installed this way
```
BATS_CORE_VERSION=1.2.1
cd /tmp && git clone --depth 1 -b v${BATS_CORE_VERSION} https://github.com/bats-core/bats-core.git
cd bats-core && ./install.sh /opt
cd .. && rm -r bats-core
ln -s /opt/bin/bats /usr/bin/bats

BATS_SUPPORT_VERSION=004e707638eedd62e0481e8cdc9223ad471f12ee
git clone https://github.com/ztombol/bats-support.git /opt/bats-support
cd /opt/bats-support && git reset --hard ${BATS_SUPPORT_VERSION}

BATS_ASSERT_VERSION=9f88b4207da750093baabc4e3f41bf68f0dd3630
git clone https://github.com/ztombol/bats-assert.git /opt/bats-assert
cd  /opt/bats-assert && git reset --hard ${BATS_ASSERT_VERSION}
```

## Run tests

```
bats e2e/
```


The tests clean after themselves, so all docker containers created during the tests, should be automatically removed.
