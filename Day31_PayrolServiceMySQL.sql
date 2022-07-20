/*----UC1--------*/
create database payroll_service;
show databases;
use payroll_service;

/*-------UC2-------*/
create table employee_payroll(
	id int not null auto_increment,
    name varchar(50) not null,
    salary Double not null,
    startDate Date not null,
    primary key(id)
);

desc employee_payroll;

/*--------UC3----------*/
insert into employee_payroll(name, salary, startDate) values('Ashish', 20000.0, '2021-01-01');
insert into employee_payroll(name, salary, startDate) values('John', 30000.0, '2021-01-02');
insert into employee_payroll(name, salary, startDate) values('Pooja', 250000.0, '2022-01-01');
insert into employee_payroll(name, salary, startDate) values('Kunal', 20000.0, '2022-01-04');

/*--------UC4----------*/
select * from employee_payroll;

/*--------UC5----------*/
select salary from employee_payroll where name = "Kunal";
select * from employee_payroll where startDate between cast('2022-01-01' as date) and Date(now());

/*--------UC6----------*/
alter table employee_payroll add gender char(1) after name;
update employee_payroll set gender = 'F' where id = 3;

/*--------UC7----------*/
select gender, sum(salary) from employee_payroll where gender = 'M' group by gender;
select gender, sum(salary) from employee_payroll where gender = 'F' group by gender;

select avg(salary) from employee_payroll;

select min(salary) as lowSalary from employee_payroll;
select max(salary) as highSalary from employee_payroll;

select count(gender) from employee_payroll where gender = 'M' group by gender;
select count(gender) from employee_payroll where gender = 'F' group by gender;

/*--------UC8----------*/
select * from employee_payroll;

alter table employee_payroll
add phoneno varchar(15),
add department varchar(50) not null after salary;

alter table employee_payroll
add address varchar(250) default 'Address' after phoneno;

/*--------UC9 , UC10----------*/
select * from employee_payroll;
alter table employee_payroll rename column salary to basic_pay;

alter table employee_payroll
add deduction int,
add taxable_pay int,
add income_tax int,
add net_pay int;

update employee_payroll set deduction=(basic_pay*0.1) where id!=0;
update employee_payroll set taxable_pay=(basic_pay-deduction) where id!=0;
update employee_payroll set income_tax=(taxable_pay*0.2) where id!=0;
update employee_payroll set net_pay=(taxable_pay-income_tax) where id!=0;

select * from employee_payroll where name="Pooja";

/*--------UC11, UC12----------*/
create table department_tbl (
	dept_id int auto_increment,
    dept_name varchar(15),
    dept_desc varchar(30),
    primary key(dept_id)
);

select * from department_tbl;

insert into department_tbl (dept_name, dept_desc) 
values("Sales","Handling sales of company"),
("Marketing", "marketing department"),
("IT", "Technical team"),
("HR","Human Resource"),
("Account","accounting of company");

alter table employee_payroll drop column department;

create table employee_department (
	id int auto_increment,
    emp_id int,
    dept_id int,
    primary key(id),
    foreign key(emp_id) references employee_payroll(id),
    foreign key(dept_id) references department_tbl(dept_id)
);

insert into employee_department (emp_id, dept_id) values (3,3);
insert into employee_department (emp_id, dept_id) values (1,3);
select * from employee_department;

select ep.id, ep.name, d.dept_name, d.dept_desc from employee_payroll ep, department_tbl d, employee_department ed
where ep.id=ed.emp_id AND d.dept_id=ed.dept_id;

create table salary_tbl (
	id int auto_increment,
    basic_pay double,
    deduction double,
    taxable_pay double,
    tax double,
    net_pay double,
    emp_id int,
    primary key (id),
    foreign key(emp_id) references employee_payroll(id)
);

insert into salary_tbl (basic_pay,deduction, taxable_pay, tax, net_pay,emp_id)
select basic_pay, deduction, taxable_pay, income_tax, net_pay,id from employee_payroll;

select * from salary_tbl;

alter table employee_payroll drop column basic_pay, drop column deduction, 
drop column taxable_pay, drop column income_tax, drop column net_pay;

select ep.id, ep.name, s.* from employee_payroll ep, salary_tbl s;

 