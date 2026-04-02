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
  registros = array [1..max] of det;
  
  mae = record
    cod_usuario, tiempo_total_de_sesiones_abiertas: integer;
    fecha: fec;
  end;
  
  maestro = file of mae;
  
  procedure leer(var arch: detalle; var r: det);
    begin
      if (not(EOF(arch))) then
        read(arch, r)
      else
        r.cod_usuario := valorGrande;        
    end;
  
  procedure iniciar_detalles(var v: detalles; var v2: registros);
    begin
      assign(v[1], 'detalle1');
      assign(v[2], 'detalle2');
      assign(v[3], 'detalle3');
      assign(v[4], 'detalle4');
      assign(v[5], 'detalle5');
      
      reset(v[1]);
      reset(v[2]);
      reset(v[3]);
      reset(v[4]);
      reset(v[5]);
      
      leer(v[1], v2[1]);
      leer(v[2], v2[2]);
      leer(v[3], v2[3]);
      leer(v[4], v2[4]);
      leer(v[5], v2[5]);
    end;
  
  procedure minimo(var v: detalles; var v2: registros; var min: det);
    var
      i, cod, pos: integer;
      f: fec;
    begin
      cod := 9999;
      f.dia := 9999;
      f.mes := 9999;
      f.anio := 9999;
      pos := -1;
    
      for i:=1 to max do
        begin
          {no entendi bien los or y =}
          //para fecha pude haber utilizado AAAAMMDD, A es año, M es mes, D es dia, ejemplo: 20260522 (2026-05-22)
          if (v2[i].cod_usuario < cod) or
                                          ((v2[i].cod_usuario = cod) and
                                          ((v2[i].fecha.anio < f.anio) or
                                          ((v2[i].fecha.anio = f.anio) and
                                          (v2[i].fecha.mes < f.mes)) or
                                          ((v2[i].fecha.anio = f.anio) and
                                          (v2[i].fecha.mes = f.mes) and
                                          (v2[i].fecha.dia < f.dia)))) then
            begin
              cod := v2[i].cod_usuario;
              f := v2[i].fecha;
              min := v2[i];     { guardo el registro mínimo }
              pos := i;
            end;
        end;
        
      if (pos <> -1) then
        leer(v[pos], v2[pos]);
    end;
    
  procedure cargar_mae(var v: detalles; var v2: registros; var m: maestro);
    var
      r_mae: mae;
      min: det;
      i: integer;
      
    begin
      iniciar_detalles(v, v2);
      minimo(v, v2, min);
      
      rewrite(m);
      while (min.cod_usuario <> valorGrande) do
        begin
          { Inicializo el registro maestro con el mínimo actual } //hubiese usado mejor var auxiliares
          r_mae.cod_usuario := min.cod_usuario;
          r_mae.fecha := min.fecha;
          r_mae.tiempo_total_de_sesiones_abiertas := 0;
          
          { Acumulo todos los registros iguales (misma clave cod+fecha) }
          {siempre uso =}
          while (min.cod_usuario = r_mae.cod_usuario) and
                                             (min.fecha.dia = r_mae.fecha.dia) and
                                             (min.fecha.mes = r_mae.fecha.mes) and
                                             (min.fecha.anio = r_mae.fecha.anio) do
            begin
              r_mae.tiempo_total_de_sesiones_abiertas := r_mae.tiempo_total_de_sesiones_abiertas
                                                         + min.tiempo_sesion;

              minimo(v, v2, min);  { busco el siguiente mínimo }
            end;

          write(m, r_mae);  { escribo en el maestro }
        end;
        
      for i:=1 to max do
        close(v[i]);
      close(m);
    end;

var
  v: detalles;
  v2: registros;
  m: maestro;
begin
  assign(m, '/var/log/maestro'); { ruta física que indica el enunciado }
  cargar_mae(v, v2, m);

end.
