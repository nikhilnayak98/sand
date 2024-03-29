# Security Architectures and Network Defence

A scalable secure network infrastructure with defined credible zones of trust. It has automated iptables firewall rules deployment. It also has tested prevention firewall rules for TCP and UDP Flood attacks.

## Network Design
![Network Design](https://raw.githubusercontent.com/nikhilnayak98/sand/main/Network%20Design.png)

## Phase 1

- [x] 1. satisfy the case-sensitive file-naming requirements of the deliverable files.
- [x] 2. define and implement credible zones of trust.
- [x] 3. define and implement re-organised IP addressing.
- [x] 4. define and implement filters between zones of trust.
- [x] 5. partially verify that connectivity is achieved / prevented as appropriate between clients and services.
- [x] 6. have hashes at the demonstration that match the hashes in the submission sandhashes.sha1 file (ie provide evidence that nothing significant has changed between the submission and the demonstration).

## Phase 2

- [x] 7. implement NAT / port-forwarding.
- [x] 8. robustly verify that connectivity is achieved / prevented as appropriate between clients and services.
- [x] 9. make a compelling case for your design.
- [x] 10. implementation of one augmented feature.

## Phase 3

- [x] 10. implementation of two further significant, distinct, augmented features.
- [x] 11. make a compelling case for your design.
- [x] 12. demonstrate comprehensive mastery of all aspects of the the submission at all scales (detail through to overall concept).

## Augmented Features:

1. TCP SYN Flood Protection.
2. UDP Flood Protection.
3. Usage of OpenVPN to connect to internal network.
4. Automation of host firewall rules deployment.
5. Usage of Squid Proxy Server to access Internet from Enterprise Zone and Extranet Zone.
6. Usage of Squid Proxy Server to block malicious websites.
7. Blocking SSH access, allow SSH only from Management Zone.
8. Blocking SSH access into root, allow SSH access only to admin account.

## How to Run Lab
- <code>cd sand-pma-starter</code>
- <code>chmod +x /shared/hostrules.sh</code>
- <code>lstart</code>
