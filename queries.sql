# 1. Fréquence d'achat
  
WITH sub_nb_commandes AS (
  SELECT
  user_id
  ,CASE
    WHEN COUNT(order_id)=1 THEN "1"
    WHEN COUNT(order_id)=2 THEN "2"
    ELSE "3+"
  END AS nb_commandes
  FROM `portfolio-e-de-crazannes.thelook.orders_2023`
  GROUP BY user_id
)
SELECT
sub_nb_commandes.nb_commandes
,COUNT(DISTINCT user_id) AS nb_clients
,ROUND(COUNT(DISTINCT user_id) / SUM(COUNT(DISTINCT user_id)) OVER () * 100,2) AS part_clients
FROM sub_nb_commandes
GROUP BY sub_nb_commandes.nb_commandes

  
# 2. Panier moyen par genre
  
WITH sub_gender AS (
  SELECT
  oi.*
  ,o.gender
  FROM `portfolio-e-de-crazannes.thelook.order_items` oi
  LEFT JOIN `portfolio-e-de-crazannes.thelook.orders` o
  USING(order_id)
)
SELECT 
gender
,COUNT(DISTINCT order_id) AS nb_commandes
,ROUND(SUM(sale_price),0) AS CA
,ROUND(SUM(sale_price)/COUNT(DISTINCT order_id),2) AS panier_moyen
FROM sub_gender

  
# 3. Délais moyens de livraison par mois
  
WITH sub_month AS (
  SELECT
    EXTRACT(MONTH FROM created_at) AS mois
    ,DATE_DIFF(delivered_at, created_at, DAY) AS delai_jours
  FROM `portfolio-e-de-crazannes.thelook.orders_2023`
  WHERE status = "Complete"
)
SELECT
  mois
  ,ROUND(AVG(delai_jours), 1) AS delai_moyen_jours
FROM sub_month
GROUP BY mois
ORDER BY mois


WHERE EXTRACT (YEAR from created_at)=2023 AND status="Complete"
GROUP BY gender
