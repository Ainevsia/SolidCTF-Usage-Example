# SolidCTF 框架使用示例

[SolidCTF 框架](https://github.com/chainflag/solidctf)是针对CTF竞赛中 `>Misc>区块链>智能合约` 分类下的赛题进行部署的一站式解决方案。本文档将以一道智能合约赛题为例介绍如何使用Solid CTF框架进行赛题部署。

## 环境准备

唯一必须安装的是docker engine，以Ubuntu为例，可以参考[官方文档](https://docs.docker.com/engine/install/ubuntu/)进行安装。在服务器无图形界面的环境下直接忽略Docker Desktop，剩下两种推荐的安装方法：新增apt源后安装或者使用deb二进制包安装，请参考官方文档进行安装。（由于docker-compose已经废弃，请尽量安装最新版本的docker compose插件）

(若pull速度不理想，请更换docker源)

## template目录文件说明

使用赛题合约替换`contracts/Challenge.sol`文件，并相应编辑`challenge.yml`中的描述信息以及一些参数。
```
$ docker ps -a
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS                  PORTS                            NAMES
40d8f42fd6df   chainflag/eth-faucet:1.1.0   "/app/eth-faucet -wa…"   8 seconds ago   Up Less than a second   0.0.0.0:8080->8080/tcp           eth_faucet
27895f385496   chainflag/solidctf:1.0.0     "tini -g -- /entrypo…"   9 seconds ago   Up 7 seconds            0.0.0.0:20000->20000/tcp         solidity-ctf-template-challenge-1
0fc084d0582e   chainflag/fogeth:latest      "/entrypoint.sh"         9 seconds ago   Up 7 seconds            80/tcp, 0.0.0.0:8545->8545/tcp   fogeth
```