# README

## アプリケーション起動手順
```
$ sudo docker-compose run web rails new . --force --no-deps --database=postgresql
$ sudo docker-compose build
```

## config/database.yml修正
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: db
  username: root
  password: password

development:
  <<: *default
  database: app_name_development

test:
  <<: *default
  database: app_name_test
```
```
$ docker-compose up
$ docker-compose exec web rails db:create
```

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
