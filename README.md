MMORealm architecture

3 servers:

Gateway - peers with authentication and clients (interface to the internet)
Authentication - peers with gateway and worlds (verifys username/password, prevents ip spam)
Worlds - peers with clients and authentication (gets token from authentication to authenticate user)

1 client:

Client - gets token from gateway allowing enter to world. 
