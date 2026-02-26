-- ============================================
-- AND フィルタ: 「和食」かつ「辛い」商品を取得
-- ============================================
--
-- やりたいこと:
--   「和食」と「辛い」の両方のタグが付いている商品を取得する
--
-- 仕組み:
--   これが中間テーブルフィルタの最も重要なパターン。
--   単純な WHERE t.name = '和食' AND t.name = '辛い' では取得できない。
--   （1行のtagが同時に2つの値を持つことはないため）
--
--   代わりに:
--   1. WHERE で対象タグ（'和食', '辛い'）に絞り込む
--   2. GROUP BY で商品ごとにまとめる
--   3. HAVING COUNT = 2 で「2つとも持っている」商品だけ残す
--
-- ポイント:
--   HAVING COUNT のテクニックは中間テーブルならでは。
--   これが「中間テーブルでフィルタができる」の核心部分。
-- ============================================

SELECT
    p.id,
    p.name,
    p.price
FROM products p
JOIN product_tags pt ON p.id = pt.product_id
JOIN tags t ON pt.tag_id = t.id
WHERE t.name IN ('和食', '辛い')
GROUP BY p.id, p.name, p.price
HAVING COUNT(DISTINCT t.id) = 2
ORDER BY p.id;

-- ============================================
-- 補足: なぜ単純な AND ではダメなのか？
-- ============================================
-- 以下のクエリは結果が0件になる（1つのタグ行が同時に2つの名前を持てない）:
--
--   SELECT p.*
--   FROM products p
--   JOIN product_tags pt ON p.id = pt.product_id
--   JOIN tags t ON pt.tag_id = t.id
--   WHERE t.name = '和食' AND t.name = '辛い';  -- ← 常に false
