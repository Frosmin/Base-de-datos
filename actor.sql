create or replace function verificar_edad() returns trigger as $$
begin
    IF EXTRACT(YEAR FROM NEW.fechnacimiento) > EXTRACT(YEAR FROM CURRENT_DATE) - 18 THEN
        raise exception 'El cliente debe ser mayor de edad';
    end if;
    return new;
end;
$$ language plpgsql;

drop trigger if exists verificar_edad on actor;
create trigger verificar_edad
    before insert
    on actor
    for each row
    execute function verificar_edad();