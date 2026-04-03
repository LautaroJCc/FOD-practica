{
8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras.
}

program ejercicio9;

const
  valorGrande = 9999;
  max_mes = 12;
  max_dia = 31;
  
type
  rango_dia = 1..max_dia;
  rango_mes = 1..max_mes;

  cliente = record
    cod_cli: integer;
    nom, ape: string;
  end;

  info = record   
    anio: integer;
    dia: rango_dia;
    mes: rango_mes;
    monto: real;
    c: cliente;
  end;
  
  maestro = file of info;
  
  procedure leer(var arch: maestro; var d: info);
    begin
      if (not(EOF(arch))) then 
        read(arch, d)
      else
        d.c.cod_cli := valorGrande;
    end;
  
  procedure informar(var arch: maestro);
    var
      d: info;
      cod, anio: integer;
      mes: rango_mes;
      monto_total, tot_men, mon_anio_cli: real;
      
    begin 
      reset(arch);
      
      leer(arch, d);
      monto_total := 0;
      while (d.c.cod_cli <> valorGrande) do
        begin
          cod := d.c.cod_cli;
          writeln(cod, d.c.nom, d.c.ape);
          
          while (cod = d.c.cod_cli) do
            begin
              anio := d.anio;
              mon_anio_cli := 0;
              
              while (cod = d.c.cod_cli) and (anio = d.anio) do
                begin
                  mes := d.mes;
                  tot_men := 0;
                  
                  while (cod = d.c.cod_cli) and (anio = d.anio) and (mes = d.mes) do
                    begin
                      tot_men := tot_men + d.monto;
                      leer(arch, d);
                    end;
                  writeln('total mensual: ', tot_men);
                  mon_anio_cli := mon_anio_cli + tot_men;          
                end;
              writeln('monto total anio: ', mon_anio_cli);
              monto_total := monto_total + mon_anio_cli;
            end;      
        end;
      writeln('monto total empresa: ', monto_total);
      close(arch);
    end;
    
var
  m: maestro;
  
begin
  assign(arch, 'maestro');
  informar(m);
end.
