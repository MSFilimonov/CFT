USE cft_bank;


/* Сформируйте отчет, который содержит все счета, относящиеся к продуктам типа ДЕПОЗИТ, 
 принадлежащих клиентам, у которых нет открытых продуктов типа КРЕДИТ. */
SELECT a.name, 
    a.client_ref, 
    cl.name
FROM accounts a, 
    clients cl
WHERE a.client_ref=cl.id 
    AND a.product_ref = 2
    AND cl.id NOT IN (SELECT cll.id
                     FROM accounts aa, clients cll
                     WHERE aa.client_ref=cll.id 
                         AND aa.product_ref = 1);
                         
                        
/* Сформируйте выборку, который содержит средние движения по счетам в рамках одного произвольного дня,
 в разрезе типа продукта.*/
                        

SELECT pt.name,  
    count(p.id) , 
    sum(r.summ), 
    AVG(r.summ)
FROM products p, 
    products_type pt, 
    accounts a , 
    records r 
WHERE p.product_type_id=pt.id 
    AND a.product_ref=p.id
    AND r.acc_ref=a.id
    AND r.oper_date = '2001-10-20'
GROUP BY pt.name;


/* Сформируйте выборку, в который попадут клиенты, у которых были операции по счетам за прошедший месяц от текущей даты. 
Выведите клиента и сумму операций за день в разрезе даты */                        

SELECT r.oper_date, 
    cl.name, 
    r.summ
FROM accounts a, 
    records r, 
    clients cl
WHERE a.client_ref=cl.id
    AND r.acc_ref=a.id
    AND r.oper_date >=  DATE(current_date) 
ORDER BY  r.oper_date;

/* В результате сбоя в базе данных разъехалась информация между остатками и операциями по счетам. 
Напишите нормализацию (процедуру выравнивающую данные), которая найдет такие счета и восстановит остатки по счету*/


UPDATE accounts
SET saldo = 0;

UPDATE accounts, records
SET accounts.saldo = case
    WHEN records.dt = 1 THEN 
         accounts.saldo - records.summ
    WHEN records.dt = 0 THEN
         accounts.saldo + records.summ
END
    WHERE accounts.id = records.acc_ref;
SELECT * FROM accounts;

/* Сформируйте выборку, который содержит информацию о клиентах, которые полностью погасили кредит,
но при этом не закрыли продукт и пользуются им дальше (по продукту есть операция новой выдачи кредита) */ 

SELECT cl.name, 
    a.name,
    a.saldo
FROM accounts a, 
    clients cl
WHERE a.client_ref=cl.id 
    AND a.product_ref = 1
    AND a.close_date IS NULL  
    AND a.saldo = 0 ;

/* Закройте продукты (установите дату закрытия равную текущей) типа КРЕДИТ, 
 у которых произошло полное погашение, но при этом не было повторной выдачи. */  
    
UPDATE accounts 
SET close_date = current_date
WHERE saldo = 0  
      AND product_ref = 1;  

 SELECT*FROM accounts

/* Закройте возможность открытия (установите дату окончания действия) для типов продуктов, 
по счетам продуктов которых, не было движений более одного месяца.*/
 
SELECT 
    DATE_FORMAT('%Y-%m', r.oper_date),
    (CASE WHEN pt.id=1 THEN 'Кредит'||count (pt.name)  ELSE 'Кредит'||0 END),
    (CASE WHEN pt.id=2 THEN 'Депозит'||count(pt.name)  ELSE 'Депозит'||0 END),
    (CASE WHEN pt.id=3 THEN 'Карта'||count(pt.name)  ELSE 'Карта'||0 END)
FROM accounts a, 
    records r, 
    products p,
    products_type pt
WHERE r.acc_ref=a.id
    AND a.product_ref=p.id
    AND p.product_type_id=pt.id
    GROUP BY DATE_FORMAT('%Y-%m', r.oper_date);
 
/* В модель данных добавьте сумму договора по продукту.
Заполните поле для всех продуктов суммой максимальной дебетовой операции по счету для продукта типа КРЕДИТ,
и суммой максимальной кредитовой операции по счету продукта для продукта типа ДЕПОЗИТ или КАРТА */
 
ALTER TABLE products
 ADD sum_dog DECIMAL(10, 2);

 UPDATE products SET sum_dog =
(
                SELECT max(r.summ)
                FROM accounts a, 
                    records r, 
                    products p,
                    product_type pt
                WHERE  r.acc_ref=a.id
                    AND a.product_ref=p.id
                    AND p.product_type_id=pt.id
                    AND pt.id=1
                GROUP BY pt.name)
WHERE product_type_id=1;
 UPDATE products SET sum_dog =
(
                SELECT MAX(r.summ)
                FROM accounts a, 
                    records r, 
                    products p,
                    product_type pt
                WHERE  r.acc_ref=a.id
                    AND a.product_ref=p.id
                    AND p.product_type_id=pt.id
                    AND pt.id=2
                GROUP BY pt.name)
WHERE product_type_id=2;
 UPDATE products SET sum_dog =
(
                SELECT MAX(r.summ)
                FROM accounts a, 
                    records r, 
                    products p,
                    product_type pt
                WHERE  r.acc_ref=a.id
                    AND a.product_ref=p.id
                    AND p.product_type_id=pt.id
                    AND pt.id=3
                GROUP BY pt.name)
WHERE product_type_id=3;
                
 SELECT*FROM products;
 
 
 
 
 
 
 
 
 
