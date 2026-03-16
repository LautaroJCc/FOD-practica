{
7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos

realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}

program ejercicio7;

const
  valorGrande = 9999;

type
  producto = record
    cod_pro, stock_act, stock_min: integer;
    nombre: string;
    precio: real;
  end;

  maestro = file of producto;

  venta = record
    cod_pro, cant_u_ven: integer;
  end;

  detalle = file of venta;

procedure leer1(var arch: maestro; var p: producto);
begin
  if (not(EOF(arch))) then
    read(arch, p)
  else
    p.cod_pro := valorGrande;
end;

procedure leer2(var arch: detalle; var v: venta);
begin
  if (not(EOF(arch))) then
    read(arch, v)
  else
    v.cod_pro := valorGrande;
end;

  procedure puntoA(var arch: detalle; var m: maestro);
  var
    p: producto;
    v: venta;
    cod: integer;
    
  begin
    assign(arch, 'nose');
    reset(arch);
    assign(m, 'maestro');
    reset(m);
    
    leer1(m, p);
    leer2(arch, v);
    while (v.cod_pro <> valorGrande) do
      begin
        cod := v.cod_pro;
      
        while (p.cod_pro <> cod) do
          leer1(m, p);
        
        while (v.cod_pro = cod) do
          begin
            p.stock_act := p.stock_act - v.cant_u_ven;
            leer2(arch, v);
          end;
        
        seek(m, filepos(m)-1);
        write(m, p);
        
        // leer1(m, p); necesario???????????????????'''''
      end;
    close(arch);
    close(m);
  end;

procedure puntoB(var m: maestro; var txt: text);
var
  p: producto;
begin
  assign(txt, 'stock_minimo.txt');
  rewrite(txt);
  leer1(m, p);
  
  while (p.cod_pro <> valorGrande) do
  begin
    if (p.stock_act < p.stock_min) then
      writeln(txt, p.cod_pro, ' ', p.stock_act, ' ', p.stock_min, ' ', p.nombre, ' ' , p.precio);
    leer1(m, p);
  end;
  
  close(m);
  close(txt);
end;

var
  txt: text;
  m: maestro;
  arch: detalle;
  op: char;

begin
  write('ingrese una opcion: ');
  readln(op);
  if (op = 'a') then
    puntoA(arch, m)
  else
    puntoB(m, txt);
end.
  
