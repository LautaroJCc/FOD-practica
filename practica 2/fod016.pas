{
16. La editorial X, autora de diversos semanarios, posee un archivo maestro con la
información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
ejemplares y total de ejemplares vendido.

Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo
}

program ejercicio16;

const
  max_dia = 32;
  max_mes = 13;
  valorGrande = 9999;
  dimf = 100;
  
type
  fecha = record 
    dia: 1..max_dia;
    mes: 1..max_mes;
    anio: integer;
  end;

  emision = record
    f: fecha;
    cod_sem, total_ejemplares, total_ejemplares_ven: integer;
    nombre_sem, descripcion: string;
    precio: real;
  end;
  
  maestro = file of emision;
  
  info = record
    f: fecha;
    cod_sem, cant_ejemplares_ven: integer;
  end;
  
  detalle = file of info;
  
  detalles = array [1..dimf] of detalle;
  reg_det = array [1..dimf] of info;
  
  procedure leer1(var arch: maestro; var e: emision);
    begin
      if (not(EOF(arch))) then 
        read(arch, e)
      else
        begin
          e.f.dia := max_dia;
          e.f.mes := max_mes;
          e.f.anio := valorGrande;
        end;
    end;
    
  procedure leer2(var arch: detalle; var inf: info);
    begin
      if (not(EOF(arch))) then 
        read(arch, inf)
     else
       begin
         inf.f.dia := max_dia;
         inf.f.mes := max_mes;
         inf.f.anio := valorGrande;
       end;
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
    
  procedure minimo(var v: detalles; var min: info; var v2: reg_det);
    var
      i, pos, anio, cod: integer;
      dia: 1..max_dia;
      mes: 1..max_mes;
      
    begin
      pos := -1;
      anio := valorGrande;
      dia := 32;
      mes := 13;
      cod := valorGrande;

      for i:=1 to dimf do
        begin
          if (v2[i].f.anio < anio) or ((v2[i].f.anio = anio) and (v2[i].f.mes < mes)) or
             ((v2[i].f.anio = anio) and (v2[i].f.mes = mes) and (v2[i].f.dia < dia)) or
             ((v2[i].f.anio = anio) and (v2[i].f.mes = mes) and (v2[i].f.dia = dia) and (v2[i].cod_sem < cod)) then //no entiendo, ver

            begin
              anio := v2[i].f.anio;
              mes := v2[i].f.mes;
              dia := v2[i].f.dia;
              cod := v2[i].cod_sem;
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
    
  procedure max_min(var ventas_max, ventas_min, ven_act, sem_max, sem_min, sem_act: integer; var f_act, f_max, f_min: fecha);
    begin
      if (ven_act > ventas_max) then
        begin
          ventas_max := ven_act;
          sem_max := sem_act;
          f_max := f_act;
        end;
      if (ven_act < ventas_min) then
        begin
          ventas_min := ven_act;
          sem_min := sem_act;
          f_min := f_act;
        end;
    end;
     
  procedure actualizar(var v: detalles; var m: maestro);
    var
      v2: reg_det;
      min: info;
      mae: emision;
      fec, f_max, f_min: fecha;
      sem, total, ventas_max, ventas_min, sem_max, sem_min: integer;      
     
    begin
      ventas_max := -1;
      ventas_min := 9999;
    
      cargar(v, v2);
      minimo(v, min, v2);     
      reset(m);
      
      leer1(m, mae);
      while (min.f.dia <> max_dia) and (min.f.mes <> max_mes) and (min.f.anio <> valorGrande) do
        begin
          fec := min.f;
          sem := min.cod_sem;
          total := 0;
          while (min.f.dia = fec.dia) and (min.f.mes = fec.mes) and (min.f.anio = fec.anio) and (min.cod_sem = sem) do
            begin
              total := total + min.cant_ejemplares_ven;
              minimo(v, min, v2);
            end;
        
          while ((min.f.dia <> max_dia) or (min.f.mes <> max_mes) or (min.f.anio <> valorGrande)) do
            leer1(m, mae);
          
          max_min(ventas_max, ventas_min, total, sem_max, sem_min, sem, fec, f_max, f_min);
          
          mae.total_ejemplares_ven := mae.total_ejemplares_ven + total;
          
          seek(m, filepos(m)-1);
          write(m, mae);
        end;
      cerrar(v);
      
      writeln('semanario con mas ventas: ', sem_max, f_max.dia, f_max.mes, f_max.anio);
      writeln('semanario con menos ventas: ', sem_min, f_min.dia, f_min.mes, f_min.anio);
    end;
    
var
  v: detalles;
  m: maestro;

begin
  assign(m, 'maestro');
  actualizar(v, m);
end.
    
  
