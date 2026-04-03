{
17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
información de las motos que posee a la venta. De cada moto se registra: código, nombre,
descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
archivos detalles. Además se debe informar cuál fue la moto más vendida.

NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.

}

program ejercicio17;

const
  max_dia = 31;
  max_mes = 12;
  dimf = 10;
  valorGrande = 9999;
  
type 
  rango_dia = 1..max_dia;
  rango_mes = 1..max_mes;

  moto = record
    cod_moto, stock_act: integer;
    nombre, modelo, descripcion, marca: string;
  end;
  
  maestro = file of moto;
  
  fecha = record
    dia: rango_dia;
    mes: rango_mes;
    anio: integer;
  end;
  
  venta = record
    cod_moto: integer;
    precio: real;
    f: fecha;
  end;
  
  detalle = file of venta;
  
  detalles = array [1..dimf] of detalle;
  reg_det = array [1..dimf] of venta;
  
  procedure leer1(var arch: maestro; var m: moto);
    begin
      if (not(EOF(arch))) then 
        read(arch, m)
      else
        m.cod_moto := valorGrande;
    end;
    
  procedure leer2(var arch: detalle; var inf: venta);
    begin
      if (not(EOF(arch))) then 
        read(arch, inf)
     else
        inf.cod_moto := valorGrande;
    end;
  
  procedure cargar(var v: detalles; var v2: reg_det);
    var
      i: integer;
      nombre: string;
    begin
      for i:=1 to dimf do
        begin
          write('ingrese un nombre: '); readln(nombre);
          assign(v[i], nombre);
          reset(v[i]); 
          leer2(v[i], v2[i]);     
        end;
    end;
    
  procedure minimo(var v: detalles; var min: venta; var v2: reg_det);
    var
      i, pos, cod: integer;
          
    begin
      pos := -1;
      cod := valorGrande;
      
      for i:=1 to dimf do
        begin
          if (v2[i].cod_moto < cod) then
            begin
              cod := v2[i].cod_moto;
              pos := i;
              min := v2[pos];
            end;
        end;
      if (pos <> -1) then
        leer2(v[pos], v2[pos]);
    end;
    
  procedure cerrar(var v: detalles);
    var
      i: integer;
    begin
      for i:=1 to dimf do
        close(v[i]);
    end;
    
  procedure actualizar(var v: detalles; var m: maestro);
    var
      v2: reg_det;
      min: venta;
      mot: moto;
      mas_vendido, cod_mas_ven, cod_act, cont: integer;
    
    begin
      cargar(v, v2);
      minimo(v, min, v2);    
      reset(m);
      mas_vendido := -1; 
      cod_mas_ven := -1; //cod
      
      leer1(m, mot);
      while (min.cod_moto <> valorGrande) do
        begin
          cod_act := min.cod_moto;
          cont := 0;
          while (cod_act = min.cod_moto) do
            begin
              cont := cont + 1;
              minimo(v, min, v2);
            end;
          
          if (cont > mas_vendido) then
            begin
              mas_vendido := cont;
              cod_mas_ven := cod_act;
            end;
             
          while (cod_act <> mot.cod_moto) do
            leer1(m, mot);
          
          mot.stock_act := mot.stock_act - cont;
          seek(m, filepos(m)-1);
          write(m, mot);
        end;
      cerrar(v);
      close(m);
      
      writeln('moto mas vendida: ', cod_mas_ven);
    end;
    
var
  v: detalles;
  m: maestro;

begin
  assign(m, 'maestro');
  actualizar(v, m);
end.
  
