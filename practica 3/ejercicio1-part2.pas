{
1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?
}

program ejercicio1_part2;

const
  valorGrande = 9999;

type
  producto = record
    cod, stock_act, stock_min: integer;
    nombre: string;
    precio_venta: real;
  end;
  
  maestro = file of producto;
  
  venta = record 
    cod, cant_uni_vend: integer;
  end;
  
  detalle = file of venta;
  
  procedure leer1(var m: maestro; var aux: producto);
    begin
      if (not(EOF(m))) then
        read(m, aux)
      else
        aux.cod := valorGrande;
    end;
    
  procedure leer2(var d: detalle; var aux: venta);
    begin
      if (not(EOF(d))) then
        read(d, aux)
      else
        aux.cod := valorGrande;
    end;
    
  procedure actualizar(var m: maestro; var d: detalle);
    var
      p: producto;
      v: venta;
      ok: boolean;
      
    begin
      reset(m);
      reset(d);
      
      leer2(d, v);
      while (v.cod <> valorGrande) do
        begin
          seek(m, 0);
          ok := false;
          leer1(m, p);
          while (p.cod <> valorGrande) and (ok = false) do
            begin
              if (p.cod = v.cod) then
                begin
                  p.stock_act := p.stock_act - v.cant_uni_vend;
                  ok := true;
                  
                  seek(m, filepos(m)-1);
                  write(m, p);
                end
              else
                leer1(m, p);
            end;
          leer2(d, v);
        end;
      close(m);
      close(d);
    end;
  //no estoy seguro, el b creo que es a
  
  {
	b. Si se sabe que cada registro del maestro se actualiza como máximo una vez,
	no es necesario reiniciar el recorrido del archivo maestro por cada registro
	del detalle. Se puede recorrer el detalle y, por cada venta, buscar una única
	vez en el maestro el producto correspondiente y actualizarlo, evitando
	búsquedas repetidas innecesarias.
  }
  
var
  m: maestro;
  d: detalle;

begin
  assign(m, 'maestro');
  assign(d, 'detalle');
  
  actualizar(m, d);
end.
  
