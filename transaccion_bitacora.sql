drop table if exists bitacora_transaccion;
create table bitacora_transaccion(
    id serial primary key,
    codmonto integer not null,
    codproducion integer  ,
    tipopago varchar(50) not null,
    planpago varchar(50) not null ,
    fechapago date not null ,
    monto integer not null ,
    fecha_modificacion timestamp,
    accion varchar(50),
    usuario varchar(50)
);

create or replace function funcion_transaccion()
    returns trigger as $$
    -- begin
        IF TG_OP = 'INSERT' THEN
        INSERT INTO bitacora_transaccion (codmonto, codproducion, tipopago, planpago, fechapago, monto, fecha_modificacion, accion, usuario)
        VALUES (new.codmonto, new.codproduccion ,new.tipopago, new.planpago, new.fechapago, new.monto, now(), TG_OP , current_user);
        return new;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO bitacora_transaccion (codmonto, codproducion, tipopago, planpago, fechapago, monto, fecha_modificacion, accion, usuario)
        VALUES (old.codmonto, old.codproduccion ,old.tipopago, old.planpago, old.fechapago, old.monto, now(), TG_OP , current_user);
        return new;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO bitacora_transaccion (codmonto, codproducion, tipopago, planpago, fechapago, monto, fecha_modificacion, accion, usuario)
        VALUES (old.codmonto, old.codproduccion ,old.tipopago, old.planpago, old.fechapago, old.monto, now(), TG_OP , current_user);
        return new;
    END IF;
    RETURN NULL;
    end;
$$ language plpgsql;


drop trigger if exists transaccion_triger_bitacora on transaccion;
create trigger transaccion_triger_bitacora
    after insert or update or delete
    on transaccion
    for each row
    execute function funcion_transaccion();