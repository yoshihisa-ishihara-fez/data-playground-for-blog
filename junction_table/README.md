# 中間テーブルによるフィルタリング検証

レストランメニュー検索システムを題材に、中間テーブル（junction table）を使った各種フィルタリングパターンを動作検証できる環境。

## 前提条件

- Docker / Docker Compose

## セットアップ

```bash
cd junction_table
docker compose up -d
```

起動すると `01_setup.sql` が自動実行され、テーブル作成とサンプルデータ投入が完了する。

## クエリの実行方法

### コンテナ内の psql で実行

```bash
# コンテナに入って psql を起動
docker compose exec db psql -U postgres -d junctiontest
```

psql 内でクエリファイルを実行：

```sql
\i /queries/01_or_filter.sql
\i /queries/02_and_filter.sql
\i /queries/03_not_filter.sql
\i /queries/04_count_filter.sql
\i /queries/05_combined_filter.sql
```

## データの確認

サンプルデータの全体像を確認したい場合：

```sql
-- 全商品とそのタグを一覧表示
SELECT p.id, p.name, p.price, STRING_AGG(t.name, ', ' ORDER BY t.id) AS tags
FROM products p
LEFT JOIN product_tags pt ON p.id = pt.product_id
LEFT JOIN tags t ON pt.tag_id = t.id
GROUP BY p.id, p.name, p.price
ORDER BY p.id;
```

## 後片付け

```bash
docker compose down
```

データも完全に削除する場合：

```bash
docker compose down -v
```
