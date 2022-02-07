# README

## 概要
EyeFarmCloudV2開発環境のWebアプリケーション

## セットアップ手順

```
$ docker-compose build
$ docker-compose run web bin/rails db:create
$ docker-compose run web bin/rails db:migrate
$ docker-compose run web bin/rails db:seed
```

## サーバの起動

```
$ docker-compose up -d
```

## ブラウザからのアクセス

http://localhost:3000 を開く

## サーバの停止

```
$ docker-compose down
```
