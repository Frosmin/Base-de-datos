CREATE OR REPLACE FUNCTION correo_existe() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM cliente WHERE correoelectronico = NEW.correoelectronico) THEN
        RAISE EXCEPTION 'El correo % ya existe en la base de datos', NEW.correoelectronico;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_correo_unico
BEFORE INSERT ON cliente
FOR EACH ROW EXECUTE PROCEDURE correo_existe();


create or replace function correo_valido() returns trigger as $$
begin
    if new.correoelectronico not like '%@%' then
        raise exception 'El correo % no es valido', new.correoelectronico;
    end if;
    return new;
end;
 $$ language plpgsql;


drop trigger if exists verificar_correo_valido on cliente;
create trigger verificar_correo_valido
    before insert
    on cliente
    for each row
    execute function correo_valido();


create or replace function verificar_edad() returns trigger as $$
begin
    IF EXTRACT(YEAR FROM NEW.fechnacimiento) > EXTRACT(YEAR FROM CURRENT_DATE) - 18 THEN
        raise exception 'El cliente debe ser mayor de edad';
    end if;
    return new;
end;
$$ language plpgsql;

drop trigger if exists verificar_edad on cliente;
create trigger verificar_edad
    before insert
    on cliente
    for each row
    execute function verificar_edad();