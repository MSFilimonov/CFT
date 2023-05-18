DROP DATABASE IF EXISTS cft_bank;
CREATE DATABASE cft_bank;
USE cft_bank;

DROP TABLE IF EXISTS clients;  
CREATE TABLE clients ( -- таблица содержит основную информацию по клиентам Банка
	id INT(10) PRIMARY KEY UNIQUE, 
	name VARCHAR(1000) NOT NULL COMMENT 'ФИО клиента',
	place_of_birth VARCHAR(1000) NOT NULL COMMENT 'место рождения клиента',
    date_of_birth DATE NOT NULL COMMENT 'дата рождения клиента',
    address VARCHAR(1000) NOT NULL COMMENT 'адрес проживания клиента',
    passport VARCHAR(100) NOT NULL COMMENT 'паспортные данные клиента'
);

DROP TABLE IF EXISTS products;  
CREATE TABLE products ( -- таблица содержит информацию о продуктах, открытых для клиента в Банке
	id INT(10) PRIMARY KEY AUTO_INCREMENT UNIQUE, 
	product_type_id INT(10) NOT NULL, -- ссылка на тип продукта
	name VARCHAR(100) NOT NULL, -- наименование продукта
    client_ref INT(10) NOT NULL, -- ссылка на клиента
    open_date DATE NOT NULL, -- дата открытия продукта
    close_date DATE, -- дата закрытия продукта
    INDEX prod_prodtype_fk(product_type_id),
    FOREIGN KEY prod_cl_fk(client_ref) REFERENCES clients(id) 
);

DROP TABLE IF EXISTS products_type;  
CREATE TABLE products_type ( -- таблица содержит информацию о типах продуктов, которые доступны для открытия клиенту
	id INT(10) PRIMARY KEY AUTO_INCREMENT UNIQUE, 
	name VARCHAR(100) NOT NULL, -- наименование типа продукта
    begin_date DATE NOT NULL, -- дата начала действия типа продукта
    end_date DATE, -- дата окончания действия типа продукта
    tarif_ref INT(10) NOT NULL, -- ссылка на тариф
    INDEX prod_type_tar_fk(tarif_ref),
    FOREIGN KEY prod_prodtype_fk(id) REFERENCES products(id) 
);

DROP TABLE IF EXISTS accounts;  
CREATE TABLE accounts ( --  таблица содержит информацию о счетах, открытых для клиента в Банке
	id INT(10) PRIMARY KEY AUTO_INCREMENT UNIQUE, 
	name VARCHAR(100) NOT NULL, -- наименование счета
    saldo DECIMAL(10,2) NOT NULL, -- остаток по счету
    client_ref INT(10) NOT NULL, -- ссылка на клиента
    open_date DATE NOT NULL, -- дата открытия счета
    close_date DATE, -- дата закрытия счета
    product_ref INT(10) NOT NULL, -- ссылка на продукт, в рамках которого открыт счет
    acc_num VARCHAR(25) NOT NULL, -- номер счета 
    INDEX acc_prod_fk(product_ref),  
    FOREIGN KEY acc_cl_fk(client_ref) REFERENCES clients(id),
    FOREIGN KEY acc_prod_fk(product_ref) REFERENCES products(id)
);

DROP TABLE IF EXISTS records;  
CREATE TABLE records ( -- таблица содержит информацию операциях по счетам
	id INT(10) PRIMARY KEY AUTO_INCREMENT UNIQUE, 
	dt BOOL NOT NULL, 
	-- признак дебетования счета, может принимать значения 1 и 0, 
	-- в случае когда значение равно 1 – остаток по счету уменьшается (дебет), 
	-- в случае когда значение равно 0 – остаток по счету увеличивается (кредит)
    acc_ref INT(10) NOT NULL, -- ссылка на счет, по которому происходит движение
    oper_date DATE NOT NULL, -- дата операции
    summ DECIMAL(10,2) NOT NULL, -- сумма операции
    INDEX rec_acc_fk(acc_ref),
    FOREIGN KEY rec_acc_fk(acc_ref) REFERENCES accounts(id)
);

DROP TABLE IF EXISTS tarifs;  
CREATE TABLE tarifs ( -- таблица содержит информацию о тарифах за операции по счетам
	id INT(10) PRIMARY KEY AUTO_INCREMENT UNIQUE, 
	name VARCHAR(100) NOT NULL, -- наименование тарифа
    cost DECIMAL(10,2) NOT NULL, -- сумма тарифа    
    FOREIGN KEY prod_type_tar_fk(id) REFERENCES products_type(tarif_ref)
);


