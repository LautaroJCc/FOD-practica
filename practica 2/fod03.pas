{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}

program ejercicio3;

const
  max = 30;
  valorAlto = 9999;
  
type
  producto = record
    cod, stock_dispo, stock_min: integer;
    nombre, desc: string;
    precio: real;
  end;
  
  archivo = file of producto;
  
  producto2 = record
    cod, cant_vend: integer;
  end;
  
  archivo2 = file of producto2;
  detalles = array [1..max] of archivo2;
  texto = text;
  
procedure leer(var arch: archivo2; var pro2: producto2);
begin
  if not eof(arch) then
    read(arch, pro2)
  else
    pro2.cod := valorAlto;
end;

procedure actualizar(var arch: archivo; var v: detalles);
var
  pro2: producto2;
  pro: producto;
  i, cant, cod: integer;
begin
  
end;

procedure cargar_txt(var arch: archivo; var arch2: texto);
var 
  pro: producto;
begin
  rewrite(arch2);
  reset(arch);

  while not eof(arch) do
  begin
    read(arch, pro);

    if (pro.stock_dispo < pro.stock_min) then
    begin
      writeln(arch2, 'Producto: ', pro.nombre);
      writeln(arch2, 'Descripcion: ', pro.desc);
      writeln(arch2, 'Stock disponible: ', pro.stock_dispo);
      writeln(arch2, 'Precio: ', pro.precio);
      writeln(arch2);
    end;
  end;
  close(arch);
  close(arch2);
end;
  
  procedure asignarDetalles(var v: detalles);
begin
  assign(v[1],'detalle1');
  assign(v[2],'detalle2');
  assign(v[3],'detalle3');
  assign(v[4],'detalle4');
  assign(v[5],'detalle5');
  assign(v[6],'detalle6');
  assign(v[7],'detalle7');
  assign(v[8],'detalle8');
  assign(v[9],'detalle9');
  assign(v[10],'detalle10');
  assign(v[11],'detalle11');
  assign(v[12],'detalle12');
  assign(v[13],'detalle13');
  assign(v[14],'detalle14');
  assign(v[15],'detalle15');
  assign(v[16],'detalle16');
  assign(v[17],'detalle17');
  assign(v[18],'detalle18');
  assign(v[19],'detalle19');
  assign(v[20],'detalle20');
  assign(v[21],'detalle21');
  assign(v[22],'detalle22');
  assign(v[23],'detalle23');
  assign(v[24],'detalle24');
  assign(v[25],'detalle25');
  assign(v[26],'detalle26');
  assign(v[27],'detalle27');
  assign(v[28],'detalle28');
  assign(v[29],'detalle29');
  assign(v[30],'detalle30');
end;
  
var
  maestro: archivo;
  v: detalles;
  txt: text;

begin
  assign(maestro,'maestro');
  assign(txt,'reporte.txt');

  asignarDetalles(v);

  actualizar(maestro, v);

  cargar_txt(maestro, txt);
end.
  
  
