

CREATE TABLE bitacora_premio
(
    id           SERIAL PRIMARY KEY,
    codpremio    integer,
    nombrepremio VARCHAR(100),
    fecha        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE bitacora_premio2
(
    id           SERIAL PRIMARY KEY,
    codpremio    INTEGER,
    nombrepremio VARCHAR(100),
    fecha        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operacion    VARCHAR(50),
    usuario      VARCHAR(100),
    detalle      TEXT
);
--
--creamos la tabla basica donde queremos guardar todo lo que se modifique en la tabla premio

create or replace function funcion_premio() returns trigger
as
$$
begin
    insert into bitacora_premio (codpremio, nombrepremio, fecha) values (new.codpremio, new.nombrepremio, now());

    return new;
end
$$
    language plpgsql;
--funcion donde que guarda todo lo antiguo en la tabla bitacora_premio mas la fecha actual
--

CREATE OR REPLACE FUNCTION funcion_premio()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO bitacora_premio2 (codpremio, nombrepremio, fecha, operacion, usuario, detalle)
        VALUES (new.codpremio, new.nombrepremio , now(), TG_OP , current_user, 'codpremio: ' || new.codpremio || ', nombrepremio: ' || new.nombrepremio);
        return new;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO bitacora_premio2 (codpremio, nombrepremio, fecha, operacion, usuario, detalle)
        VALUES (old.codpremio, old.nombrepremio , now(), TG_OP , current_user, 'codpremio: ' || old.codpremio || ', nombrepremio: ' || old.nombrepremio);
        return new;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO bitacora_premio2 (codpremio, nombrepremio, fecha, operacion, usuario, detalle)
        VALUES (old.codpremio, old.nombrepremio , now(), TG_OP , current_user, 'codpremio: ' || old.codpremio || ', nombrepremio: ' || old.nombrepremio);
        return new;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;




drop trigger if exists triger_premio_update on premio;
create  trigger triger_premio_update
    before update
    on premio
    for each row
execute function funcion_premio();

drop trigger if exists triger_premio_delete on premio;
create trigger triger_premio_delete
    before delete
    on premio
    for each row
execute procedure funcion_premio();

drop trigger if exists triger_premio_insert on premio;
create  trigger triger_premio_insert
    before insert
    on premio
    for each row
execute procedure funcion_premio();


UPDATE public.premio
SET nombrepremio = 'Premios sur3'
WHERE codpremio = 17;
--ejemplo de la update


CREATE OR REPLACE FUNCTION funcion_premio()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO bitacora_premio2 (codpremio, nombrepremio, fecha, operacion, usuario, detalle)
        VALUES (new.codpremio, new.nombrepremio , now(), TG_OP , current_user, 'codpremio: ' || new.codpremio || ', nombrepremio: ' || new.nombrepremio);
        return new;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO bitacora_premio (codpremio, nombrepremio, fecha)
        VALUES (old.codpremio, old.nombrepremio , now());
        return new;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO bitacora_premio (codpremio, nombrepremio, fecha)
        VALUES (old.codpremio, old.nombrepremio , now());
        return new;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;