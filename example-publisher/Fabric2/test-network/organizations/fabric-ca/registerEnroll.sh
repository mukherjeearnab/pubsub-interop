

function createOrg1 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org1.pub.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.pub.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7154 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org1.pub.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org1.pub.com/peers
  mkdir -p organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7154 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/msp --csr.hosts peer0.org1.pub.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7154 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls --enrollment.profile tls --csr.hosts peer0.org1.pub.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org1.pub.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.pub.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org1.pub.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.pub.com/tlsca/tlsca.org1.pub.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org1.pub.com/ca
  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/peers/peer0.org1.pub.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.pub.com/ca/ca.org1.pub.com-cert.pem

  mkdir -p organizations/peerOrganizations/org1.pub.com/users
  mkdir -p organizations/peerOrganizations/org1.pub.com/users/User1@org1.pub.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7154 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.pub.com/users/User1@org1.pub.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.pub.com/users/User1@org1.pub.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/org1.pub.com/users/Admin@org1.pub.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7154 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.pub.com/users/Admin@org1.pub.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org1.pub.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.pub.com/users/Admin@org1.pub.com/msp/config.yaml

}


function createOrg2 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/org2.pub.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.pub.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8154 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8154-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8154-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8154-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8154-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org2.pub.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/org2.pub.com/peers
  mkdir -p organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8154 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/msp --csr.hosts peer0.org2.pub.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8154 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls --enrollment.profile tls --csr.hosts peer0.org2.pub.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/org2.pub.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.pub.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/org2.pub.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.pub.com/tlsca/tlsca.org2.pub.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/org2.pub.com/ca
  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/peers/peer0.org2.pub.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.pub.com/ca/ca.org2.pub.com-cert.pem

  mkdir -p organizations/peerOrganizations/org2.pub.com/users
  mkdir -p organizations/peerOrganizations/org2.pub.com/users/User1@org2.pub.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8154 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.pub.com/users/User1@org2.pub.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.pub.com/users/User1@org2.pub.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/org2.pub.com/users/Admin@org2.pub.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8154 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.pub.com/users/Admin@org2.pub.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/org2.pub.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.pub.com/users/Admin@org2.pub.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/pub.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/pub.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9154 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9154-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9154-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9154-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9154-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/pub.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/pub.com/orderers
  mkdir -p organizations/ordererOrganizations/pub.com/orderers/pub.com

  mkdir -p organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9154 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/msp --csr.hosts orderer.pub.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pub.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9154 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls --enrollment.profile tls --csr.hosts orderer.pub.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/msp/tlscacerts/tlsca.pub.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/pub.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/pub.com/orderers/orderer.pub.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pub.com/msp/tlscacerts/tlsca.pub.com-cert.pem

  mkdir -p organizations/ordererOrganizations/pub.com/users
  mkdir -p organizations/ordererOrganizations/pub.com/users/Admin@pub.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9154 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pub.com/users/Admin@pub.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pub.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/pub.com/users/Admin@pub.com/msp/config.yaml


}
