-- Conhecenho a estrutura das tabelas
describe channels;
describe deliveries;
describe hubs;
describe orders;
describe payments;
describe stores;

-- Contagem de registros por tabela
select COUNT(*) as total_channels from channels c;
select COUNT(*) as total_deliveries from deliveries d;
select COUNT(*) as total_hubs from hubs h ;
select COUNT(*) as total_orders from orders o ;
select COUNT(*) as total_payments from payments p ;
select COUNT(*) as total_stores from stores s ;

-- Resumo estatístico das vendas
select 
	COUNT(*) as total_de_pedidos,
	AVG(order_amount) as media_valor_pedido,
	MIN(order_amount) as min_valor_pedido,
	MAX(order_amount) as max_valor_pedido
from orders o; 

-- Distribuição dos valores dos pedidos
select
	order_amount,
	count(*) as frequencia
from orders o
group by order_amount
order by frequencia desc;

-- quantidade de pedidos até 100 e maiores que 100
select
	case 
		when order_amount < 100 then 'Até 100'
		else 'Acima de 100'
	end as faixa_valor,
	count(*) as frequencia
from orders o
group by 
	case
		when order_amount < 100 then 'Até 100'
		else 'Acima de 100'
	end;

-- Quantidade de pedidos cancelados
SELECT 
    order_status, 
    COUNT(*) AS total_orders,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders)) AS porcentagem
FROM orders 
GROUP BY order_status;

-- Criando nova tabela orders
create table orders_new(
	order_id int,
	store_id int,
	channel_id int,
	payment_order_id int,
	delivery_order_id int,
	order_status varchar(50),
	order_amount double,
	order_delivery_fee int,
	order_delivery_cost int,
	order_moment_created varchar(50),
	order_moment_finished varchar(50)
);

-- Adicionando dados a nova tabela
insert into orders_new 
	(order_id, store_id, channel_id, payment_order_id, delivery_order_id, order_status, order_amount, order_delivery_fee, order_delivery_cost,
	order_moment_created, order_moment_finished)
select
	order_id, store_id, channel_id, payment_order_id, delivery_order_id, order_status, order_amount, order_delivery_fee, order_delivery_cost,
	order_moment_created, order_moment_finished
from orders ;

-- Total de entregas por hubs
select h.hub_name, count(on2.order_id) as quantidade_pedidos
from orders_new on2 join stores s on s.store_id = on2.store_id
					join hubs h on s.hub_id = h.hub_id
group by h.hub_name
order by quantidade_pedidos desc;

-- Valor medio dos pedidos por cidade
select h.hub_city, avg(on2.order_amount) as media
from orders_new on2 join stores s on s.store_id = on2.store_id
					join hubs h on s.hub_id = h.hub_id
group by h.hub_city 
order by media desc;

-- Total de entregas por cidade
select h.hub_city, count(on2.order_id) as quantidade
from orders_new on2 join stores s on s.store_id = on2.store_id
					join hubs h on s.hub_id = h.hub_id
group by h.hub_city 
order by quantidade desc; 




/* TRATAMENTO DOS DADOS*/


-- Adicionar nova coluna com tempo da entrega
alter table orders_new add column inicio_pedido datetime;
UPDATE orders_new 
SET inicio_pedido = STR_TO_DATE(order_moment_created, '%c/%e/%Y %r');

alter table orders_new add column fim_pedido datetime;
UPDATE orders_new 
SET fim_pedido = STR_TO_DATE(order_moment_finished, '%c/%e/%Y %r')
WHERE order_moment_finished IS NOT NULL AND order_moment_finished <> '';

alter table orders_new drop column order_moment_created;
alter table orders_new drop column order_moment_finished;


-- Removendo linhas duplicadas
DELETE FROM orders_new
WHERE order_id IN (
    SELECT order_id
    FROM (
        SELECT order_id, ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS row_num
        FROM orders
    ) t
    WHERE t.row_num > 1
);

select count(*) as total from orders_new;

-- Quantidade de nulos no tempo final do pedido
select count(case when fim_pedido is null then 1 end) as quantidade_nulos
from orders_new;
-- (TODOS OS PEDIDOS COM NULO NO TEMPO FINAL FORAM CANCELADOS, POR ISSO NAO EXCLUIR )





/* RESPONDENDO AS QUESTÕES DO NEGÓCIO 
 */

-- Quais são os marketplaces mais rentáveis para os lojistas?
select c.channel_name, sum(on2.order_amount) as valor_total
from orders_new on2 join channels c on on2.channel_id = c.channel_id
group by c.channel_name 
order by valor_total desc;

-- Qual é o tempo médio de entrega por hub?
select h.hub_name, avg(timestampdiff(hour,inicio_pedido, fim_pedido)) as media_tempo_entrega
from orders_new on2 join stores s on on2.store_id = s.store_id 
					join hubs h on h.hub_id  = s.hub_id
group by h.hub_name
order by media_tempo_entrega desc;

-- Qual é o desempenho dos entregadores (drivers) em termos de número de entregas e tempo médio de entrega?
select driver_modal, count(driver_modal) as quantidade_entregas, avg(timestampdiff(hour, inicio_pedido, fim_pedido)) as tempo_medio_entrega
from drivers d join deliveries d2 on d.driver_id = d2.driver_id 
				join orders_new on2 on on2.delivery_order_id = d2.delivery_order_id
group by driver_modal
order by quantidade_entregas desc;

-- O tipo de contratação interfere no desempenho do entregador?
select d.driver_type, count(d.driver_type),
	case
	when on2.order_status = 'FINISHED' then 'Entrege'
	else 'Cancelada'
	end as status_pedido
from drivers d 
join deliveries d2 on d.driver_id = d2.driver_id 
join orders_new on2 on on2.delivery_order_id = d2.delivery_order_id 
group by d.driver_type, status_pedido;

-- Qual o volume de pedidos por logista e o valor médio de venda?
select store_name, count(order_id) as quantidade_pedidos, round(avg(order_amount)) as media_valor_venda
from stores s join orders_new on2 on s.store_id = on2.store_id
group by store_name
order by quantidade_pedidos desc, media_valor_venda desc ;

-- Como os pagamentos realizados ao Delivery Center variam por marketplace e qual é a tendência ao longo do tempo?
select p.payment_method, count(p.payment_method) as quantidade, round(sum(payment_amount)) as valor_total
from orders_new on2 join payments p on on2.payment_order_id  = p.payment_order_id 
					join channels c on c.channel_id = on2.channel_id 
group by p.payment_method
order by quantidade desc;



























