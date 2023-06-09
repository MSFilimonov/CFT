USE cft_bank;

INSERT INTO clients (id, name, place_of_birth, date_of_birth, address, passport)
VALUES
(1, 'Сидоров Иван Петрович', 'Россия, Московская облать, г. Пушкин', '01.01.2001', 'Россия, Московская облать, г. Пушкин, ул. Грибоедова, д. 5', '2222 555555, выдан ОВД г. Пушкин, 10.01.2015'),
(2, 'Иванов Петр Сидорович', 'Россия, Московская облать, г. Клин', '01.01.2001', 'Россия, Московская облать, г. Клин, ул. Мясникова, д. 3', '4444 666666, выдан ОВД г. Клин, 10.01.2015'),
(3, 'Петров Сиодр Иванович', 'Россия, Московская облать, г. Балашиха', '01.01.2001', 'Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7', '4444 666666, выдан ОВД г. Клин, 10.01.2015'),
(4, 'Павлов Павел Павлович', 'Россия, Московская облать, г. Красногорск', '01.01.2001', 'Россия, Московская облать, г. Красногорск, ул. Ленина, д. 9', '2313 123456, выдан ОВД г. Красногорск, 10.01.2015');

INSERT INTO products (id, product_type_id, name, client_ref, open_date, close_date)
VALUES
(1, 1, 'Кредитный договор с Сидоровым И.П..', 1, '01.06.2015', null),
(2, 2, 'Депозитный договор с Ивановым П.С.', 2, '01.08.2017', null),
(3, 3, 'Карточный договор с Петровым С.И.', 3, '01.08.2017', null),
(4, 1, 'Кредитный договор с Павловым П.П.', 3, '01.08.2017', null),
(5, 2, 'Депозитный договор с Павловым П.П.', 3, '01.08.2017', null);

INSERT INTO products_type (id, name, begin_date, end_date, tarif_ref)
VALUES
(1, 'КРЕДИТ', '01.01.2018', null, 1),
(2, 'ДЕПОЗИТ', '01.01.2018', null, 2),
(3, 'КАРТА', '01.01.2018', null, 3);

INSERT INTO accounts (id, name, saldo, client_ref, open_date, close_date, product_ref, acc_num)
VALUES
(1, 'Кредитный счет для Сидоровым И.П..', -2000, 1, '01.06.2015', null, 1, '45502810401020000022'),
(2, 'Депозитный счет для Ивановым П.С.', 6000, 2, '01.08.2017', null, 2, '42301810400000000001'),
(3, 'Карточный счет для Петровым С.И.', 8000, 3, '01.08.2017', null, 3, '40817810700000000001'),
(4, 'Кредитный счет для Павлова П.П.', 0, 4, '01.08.2017', null, 4, '40817810700000500001'),
(5, 'Депозитный счет для Павлова П.П.', 300, 4, '01.08.2017', null, 5, '42301810400000000002');

INSERT INTO tarifs (id, name, cost)
VALUES
('1','Тариф за выдачу кредита', '10'),
('2','Тариф за открытие счета', '10'),
('3','Тариф за обслуживание карты', '10');

INSERT INTO records (id, dt, summ, acc_ref, oper_date)
VALUES
(1, 1, 5000, 1, '01.06.2015'),
(2, 0, 1000, 1, '01.07.2015'),
(3, 0, 2000, 1, '01.08.2015'),
(4, 0, 3000, 1, '01.09.2015'),
(5, 1, 5000, 1, '01.10.2015'),
(6, 0, 3000, 1, '01.10.2015'),
(7, 0, 10000, 2, '01.08.2017'),
(8, 1, 1000, 2, '05.08.2017'),
(9, 1, 2000, 2, '21.09.2017'),
(10, 1, 5000, 2, '24.10.2017'),
(11, 0, 6000, 2, '26.11.2017'),
(12, 0, 120000, 3, '08.09.2017'),
(13, 1, 1000, 3, '05.10.2017'),
(14, 1, 2000, 3, '21.10.2017'),
(15, 1, 5000, 3, '24.10.2017');


