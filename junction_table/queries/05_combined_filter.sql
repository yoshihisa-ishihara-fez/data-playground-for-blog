-- ============================================
-- 複合フィルタ: 「和食」で「辛い」かつ「乳製品なし」
-- ============================================
--
-- やりたいこと:
--   乳製品アレルギーの人が食べられる、辛い和食を探す
--   → AND フィルタ + NOT フィルタの組み合わせ
--
-- 仕組み:
--   1. AND フィルタ（02 と同じ手法）で「和食 AND 辛い」を絞り込む
--   2. NOT EXISTS（03 と同じ手法）で「乳製品」を除外する
--
-- ポイント:
--   中間テーブルの真価は、こうした複合条件の組み合わせ。
--   タグの種類（味・ジャンル・アレルギー）をまたいだ横断的な検索が
--   SQLの組み合わせだけで実現できる。
-- ============================================

SELECT
    p.id,
    p.name,
    p.price
FROM products p
JOIN product_tags pt ON p.id = pt.product_id
JOIN tags t ON pt.tag_id = t.id
WHERE t.name IN ('和食', '辛い')
  AND NOT EXISTS (
      SELECT 1
      FROM product_tags pt2
      JOIN tags t2 ON pt2.tag_id = t2.id
      WHERE pt2.product_id = p.id
        AND t2.name = '乳製品'
  )
GROUP BY p.id, p.name, p.price
HAVING COUNT(DISTINCT t.id) = 2
ORDER BY p.id;
