-- ============================================
-- 集計フィルタ: タグが3つ以上付いている商品
-- ============================================
--
-- やりたいこと:
--   タグがたくさん付いている商品（＝特徴が多い商品）を取得する
--
-- 仕組み:
--   中間テーブルの行数を商品ごとに COUNT し、
--   HAVING で 3 以上のものだけ残す。
--
-- ポイント:
--   中間テーブルの「行数」が、そのまま「商品の特徴の数」になる。
--   これは正規化された中間テーブル設計だからこそできる集計。
-- ============================================

SELECT
    p.id,
    p.name,
    p.price,
    COUNT(pt.tag_id) AS tag_count,
    STRING_AGG(t.name, ', ' ORDER BY t.id) AS tags
FROM products p
JOIN product_tags pt ON p.id = pt.product_id
JOIN tags t ON pt.tag_id = t.id
GROUP BY p.id, p.name, p.price
HAVING COUNT(pt.tag_id) >= 3
ORDER BY tag_count DESC, p.id;
