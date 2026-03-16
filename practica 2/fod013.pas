{
13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
del mismo (información guardada acerca de los movimientos que ocurren en el server) que
se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.

a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX..............cantidadMensajesEnviados
.............
nro_usuarioX+n...........cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema.
}

program ejercicio13;

const 
  valorGrande = 9999;
  
type
  info = record
    nro_usuario, cantidadMailEnviados: integer;
    nombreUsuario, nombre, apellido: string;
  end;
  
  archivo = file of info;
  
  server = record
    nro_usuario: integer;
    cuentaDestino, cuerpoMensaje: string;
  end;
  
  archivo2 = file of server;
  
  procedure leer(var arch: archivo2; var s: server);
    begin
      if (not(EOF(arch))) then
        read(arch, s)
      else
        s.nro_usuario := valorGrande;
    end;
    
  procedure leer2(var arch: archivo; var m: info);
    begin
      if (not(EOF(arch))) then
        read(arch, m)
      else
        m.nro_usuario := valorGrande;
    end;
    
  procedure actualizar(var arch: archivo2; var maestro: archivo);
    var
      s: server;
      nro, cant: integer;
      m: info;
    
    begin
      reset(arch);
      reset(maestro);
      
      leer(arch, s);
      leer2(maestro, m); //mas limpio aca
      while (s.nro_usuario <> valorGrande) do
        begin
          nro := s.nro_usuario; 
          cant := 0;
          while (nro = s.nro_usuario) do
            begin
              cant :=cant +1;
              leer(arch, s)
            end;
            
          while (m.nro_usuario <> valorGrande) and (m.nro_usuario <> nro) do //inecesario la primer condicion
            leer2(maestro, m);
            
          if (m.nro_usuario = nro) then //inecesario chequear, siempre se encuentra 
            begin
              m.cantidadMailEnviados := m.cantidadMailEnviados + cant;
              seek(maestro, filepos(maestro)-1);
              write(maestro, m);
            end;
        end;
      close(arch);
      close(maestro);
    end;
  
procedure puntoB(var arch: archivo2; var maestro: archivo);
var
      s: server;
      cant: integer;
      m: info;
      txt: text;

begin
  assign(txt, 'informe.txt');

  reset(arch);
  reset(maestro);
  rewrite(txt);

  leer(arch, s);

  while not eof(maestro) do
  begin
    read(maestro, m);
    cant := 0;

    while (s.nro_usuario = m.nro_usuario) do
    begin
      cant := cant + 1;
      leer(arch, s);
    end;

    writeln(txt, m.nro_usuario,'..............',cant);
  end;

  close(arch);
  close(maestro);
  close(txt);
end;

var
  arch: archivo;
  maestro: archivo2;

begin
  assign(maestro, '/var/log/logmail.dat');
  assign(arch, 'detalle');

  { punto A: actualizar el maestro con los mails del día }
  actualizar(maestro, arch);

  { punto B: generar el informe }
  puntoB(maestro, arch);

end.
  
