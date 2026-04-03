{
14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program ejrecicio14; //la logica esta correcta creo

const
  max_dia = 32;
  max_mes = 13;
  dimf = 2;
  valorGrande = 'ZZZZ';

type
  rango_dia = 1..max_dia;
  rango_mes = 1..max_mes;
  
  fec = record
    dia: rango_dia;
    mes: rango_mes;
    anio: integer;
  end;
  
  prox_vuelos = record
    destino: string;
    fecha: fec;
    hs_salida, cant_asientos_dis: integer;
  end;
  
  maestro = file of prox_vuelos;

  info = record
    dat: prox_vuelos;
    cant_asi_comp: integer;
  end;
  
  detalle = file of info;
  
  detalles = array [1..dimf] of detalle;
  reg = array [1..dimf] of info;
  
  vuelo = record
    destino: string;
    f: fec;
    hora: integer;
  end;
  
  lista = ^nodo;
  nodo = record
    dato: vuelo;
    sig: lista;
  end;
  
  procedure leer(var arch: maestro; var p: prox_vuelos);
    begin
      if (not(EOF(arch))) then 
        read(arch, p)
      else
        p.destino := valorGrande;
    end;
    
  procedure leer2(var arch: detalle; var inf: info);
    begin
      if (not(EOF(arch))) then 
        read(arch, inf)
      else
        inf.dat.destino := valorGrande;
    end;
  
  procedure cargar(var v: detalles; var v2: reg);
    var
      i: integer;
      nombre: string;
    begin
      for i:=1 to dimf do
        begin
          write('ingrese un nombre: '); readln(nombre); //NO ESTOY SEGURO, CREO QUE ERA MEJOR PONERLOS EN PPL Y NO POR TECLADO
          assign(v[i], nombre);
          reset(v[i]); 
          leer2(v[i], v2[i]);     
        end;
    end;
    
  procedure minimo(var v: detalles; var min: info; var v2: reg);
    var
      i, pos, anio, hsSalida: integer;
      destino: string;
      dia: rango_dia;
      mes: rango_mes;
      
    begin
      destino := valorGrande;
      pos := -1;
      anio := 9999;
      dia := 32;
      mes := 13;
      hsSalida := 9999;
      for i:=1 to dimf do
        begin //para fecha podia haber usado AAAAMMDD
          if (v2[i].dat.destino < destino) or
   ((v2[i].dat.destino = destino) and (v2[i].dat.fecha.anio < anio)) or
   ((v2[i].dat.destino = destino) and (v2[i].dat.fecha.anio = anio) and (v2[i].dat.fecha.mes < mes)) or
   ((v2[i].dat.destino = destino) and (v2[i].dat.fecha.anio = anio) and (v2[i].dat.fecha.mes = mes) and (v2[i].dat.fecha.dia < dia)) or
   ((v2[i].dat.destino = destino) and (v2[i].dat.fecha.anio = anio) and (v2[i].dat.fecha.mes = mes) and (v2[i].dat.fecha.dia = dia) and (v2[i].dat.hs_salida < hsSalida)) then //no entiendo, ver

            begin
              destino := v2[i].dat.destino;
              anio := v2[i].dat.fecha.anio;
              mes := v2[i].dat.fecha.mes;
              dia := v2[i].dat.fecha.dia;
              hsSalida := v2[i].dat.hs_salida;
              pos := i;
              min := v2[pos];
            end;
        end;
      if (pos <> -1) then
        leer2(v[pos], v2[pos]);
    end;
    
  procedure agregar_Adelante(var L: lista; var d: vuelo);
    var
      nuevo: lista;
    begin
      new(nuevo);
      nuevo^.dato := d;
      nuevo^.sig := L;
      L := nuevo;
    end;
  
  procedure actualizar(var v: detalles; var m: maestro; var L: lista);
    var 
      v2: reg;
      min: info;
      destino: string;
      f: fec;
      hsSalida, cant, num: integer;
      reg_m: prox_vuelos;
      d: vuelo;
      
    begin
      cargar(v, v2);
      minimo(v, min, v2);

      leer(m, reg_m);
      
      write('ingrese la cant especifica: '); readln(num);
      while (min.dat.destino <> valorGrande) do
        begin
          destino := min.dat.destino;
          f := min.dat.fecha;
          hsSalida := min.dat.hs_salida;
          cant := 0;
          
          while (destino = min.dat.destino) and (min.dat.fecha.dia = f.dia) and (min.dat.fecha.mes = f.mes) and
                (min.dat.fecha.anio = f.anio) and (min.dat.hs_salida = hsSalida) do
            begin
              cant := cant + min.cant_asi_comp;
              minimo(v, min, v2);
            end;
          
           { busco el vuelo en el maestro }
          while ( (reg_m.destino <> destino) or
                 (reg_m.fecha.dia <> f.dia) or
                 (reg_m.fecha.mes <> f.mes) or
                 (reg_m.fecha.anio <> f.anio) or
                 (reg_m.hs_salida <> hsSalida) ) do
            
              leer(m, reg_m);//porque puede no ser el maestro actual el detalle procesado
           
                             
          { actualizo }
         reg_m.cant_asientos_dis := reg_m.cant_asientos_dis - cant;
         
         if (reg_m.cant_asientos_dis < num) then //extra
           begin       
             d.destino := reg_m.destino;
             d.f := reg_m.fecha;
             d.hora := reg_m.hs_salida;
             agregar_Adelante(L, d);
           end;
         
         seek(m, filepos(m)-1);
         write(m, reg_m);
       end; 
     close(v[1]); //hacer for japa
     close(v[2]);
     close(m);
   end;
    
var
  v: detalles;
  m: maestro;
  L: lista;
  
begin
  L := NiL;
  assign(m,'maestro');
  reset(m);
  actualizar(v, m, L);
end.    

