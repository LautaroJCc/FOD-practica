{
4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program ejercicio4;

const
  max = 5;
  valorGrande = 9999;

type
  fec = record
    dia, mes, anio: integer;
  end;

  det = record
    cod_usuario, tiempo_sesion: integer;
    fecha: fec;
  end;
  
  detalle = file of det;
  
  detalles = array [1..max] of detalle;
  
  mae = record
    cod_usuario, tiempo_total_de_sesiones_abiertas: integer;
    fecha: fec;
  end;
  
  maestro = file of mae;
  
  procedure iniciar_detalles(var v: detalles);
    begin
      assign(v[1], 'detalle1');
      assign(v[2], 'detalle2');
      assign(v[3], 'detalle3');
      assign(v[4], 'detalle4');
      assign(v[5], 'detalle5');
    end;
    
  procedure leer(var arch: archivo; var r: det);
    begin
      if (not(EOF(arch))) then
        read(arch, det)
      else
        r.cod_usuario := valorGrande;        
    end;
    
  procedure cargar_mae(var v: detalles; var maes: maestro);
    var
      d: det;
      cod_act, tiempo_total_de_sesiones_abiertas, i: integer;
      f: fecha;
    
    begin
      
      for i:=1 to max do
        begin
          reset(v[i]);
          leer(v[i], d);
          while (d.cod_usuario <> valorGrande) do
            begin
              cod_act := d.cod_usuario;
          
              while (cod_act = d.cod_usuario) do
                begin
                  f := d.fecha;
                  tiempo_total_de_sesiones_abiertas := 0;
              
                  while (cod_act = d.cod_usuario) and
                        ((f.dia = d.fecha.dia) and (f.mes = d.fecha.mes) and (f.anio = d.fecha.anio)) do
                    begin
                      tiempo_total_de_sesiones_abiertas := tiempo_total_de_sesiones_abiertas + d.tiempo_sesion;
                      leer(v[i], d);             
                    end;
              
                  //procedure para agregar maestro             
                end;      
            end;
          close(v[i]);     
        end;
    end;
        
    
var
  v: detalles;
  maes: maestro;

begin
  iniciar_detalles(v);
  assign(mae,'/var/log/maestro');
  
  
end.
  
