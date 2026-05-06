defmodule Gimnasio do
  @moduledoc """
  Sistema de gestión de socios para un gimnasio.

  Módulos:
    - Gimnasio.Socio          → Struct y validaciones del socio
    - Gimnasio.Logica         → Lógica de negocio (CRUD + consultas)
    - Gimnasio.GestionArchivos → Lectura/escritura de socios.csv
    - Gimnasio.Menu           → Interfaz de consola

  Para ejecutar:
    mix run -e "Gimnasio.main()"
  """

  def main do
    Gimnasio.Menu.iniciar()
  end
end
