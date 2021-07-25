/*CREATE TABLE usuario (
    userid character varying(40)  NOT NULL,
    nombre character varying(40) NOT NULL,
    password character varying(40) NOT NULL
) WITH (oids = false);
CREATE TABLE auditoria (
 usuario character varying(40)  NOT NULL,
	IP  character varying(20)  NOT NULL,
	fechalog  DATE  default NULL,
	horalog   timestamp default NULL
);*/
CREATE OR REPLACE FUNCTION random_date()
RETURNS timestamp
LANGUAGE PLPGSQL
AS $$
DECLARE
  output timestamp := (SELECT now());
BEGIN
   output := (select timestamp '2014-01-10 20:00:00' +
       random() * (timestamp '2020-01-20 20:00:00' -
                   timestamp '2020-01-10 10:00:00'));
  RETURN output;				   
END;
$$
 
CREATE OR REPLACE FUNCTION random_text()
    RETURNS TEXT
    LANGUAGE PLPGSQL
    AS $$
    DECLARE
        possible_chars TEXT := 'abcdefghijklmnopqrstuvwxyz';
        output TEXT := '';
        i INT4;
        pos INT4;
    BEGIN

        FOR i IN 1..1 * 2 LOOP
            pos := FLOOR( (length(possible_chars) + 1) * random());
            output := output || substr(possible_chars, pos, 1);
        END LOOP;

        RETURN output;
    END;
    $$;
 
CREATE OR REPLACE FUNCTION random_user()
    RETURNS TEXT
    LANGUAGE PLPGSQL
    AS $$
    DECLARE
	possible_user TEXT ARRAY  DEFAULT  ARRAY['tchambil', 'jperez', 'mparia', 'lpari', 'juanes', 'mmario', 'amaria', 'lalaron','james','john','robert','michael','william','david','richard','charles','joseph','thomas','christopher','daniel','paul','mark','donald','george','kenneth','steven','edward','brian','ronald','anthony','kevin','jason','matthew','gary','timothy','jose','larry','jeffrey','frank','scott','eric','stephen','andrew','raymond','gregory','joshua','jerry','dennis','walter','patrick','peter','harold','douglas','henry','carl','arthur','ryan','roger','joe','juan','jack','albert','jonathan','justin','terry','gerald','keith','samuel','willie','ralph','lawrence','nicholas','roy','benjamin','bruce','brandon','adam','harry','fred','wayne','billy','steve','louis','jeremy','aaron','randy','howard','eugene','carlos','russell','bobby','victor','martin','ernest','phillip','todd','jesse','craig','alan','shawn','clarence','sean','philip','chris','johnny','earl','jimmy','antonio'];
    BEGIN

        RETURN possible_user[FLOOR(random() * array_length(possible_user, 1)) + 1]||random_text();
    END;
    $$;

Create or replace function random_ip(length integer) returns text as
$$
declare
  chars text[] := '{0,1,2,3,4,5,6,7,8,9}';
  result text := '';
  i integer := 0;
begin
  if length < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..3 loop
    for i in 1..length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
    result := result || '.';
  end loop;

  return result;
end;
$$ language plpgsql;
select random_ip(3);
 

insert into auditoria
SELECT random_user() as usuario, 
random_ip(3) as ip, 
random_date() as fechalog,
random_date() as horalog
FROM (SELECT generate_series(1, 60000000) as usuario) as usuario; 
