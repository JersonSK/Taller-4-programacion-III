defmodule Gimnasio.Menu do
  @moduledoc """
  Interfaz de consola para el sistema de gestión del gimnasio.
  Todas las funcionalidades son accesibles desde el menú interactivo.
  """

  alias Gimnasio.{Logica, Socio}

  @separador String.duplicate("─", 50)

  # ─── Punto de entrada ──────────────────────────────────────────────

  def iniciar do
    IO.puts("\n╔══════════════════════════════════════════════╗")
    IO.puts("║     SISTEMA DE GESTIÓN - GIMNASIO ELIXIR     ║")
    IO.puts("╚══════════════════════════════════════════════╝")

    case Logica.cargar() do
      {:ok, socios} ->
        total = map_size(socios)
        IO.puts("✓ Datos cargados: #{total} socio(s) registrado(s).\n")
        loop(socios)

      {:error, razon} ->
        IO.puts("✗ Error al cargar datos: #{razon}")
        System.halt(1)
    end
  end

  # ─── Bucle principal ───────────────────────────────────────────────

  defp loop(socios) do
    mostrar_menu()
    opcion = leer_linea("Elige una opción: ")

    case opcion do
      "1"  -> loop(opcion_crear_socio(socios))
      "2"  -> loop(opcion_eliminar_socio(socios))
      "3"  -> loop(opcion_inscribir_clase(socios))
      "4"  -> loop(opcion_desinscribir_clase(socios))
      "5"  -> loop(opcion_buscar_socio(socios))
      "6"  -> loop(opcion_listar_socios(socios))
      "7"  -> loop(opcion_socios_en_clase(socios))
      "8"  -> loop(opcion_clases_de_socio(socios))
      "9"  -> loop(opcion_estadisticas(socios))
      "0"  ->
        IO.puts("\n¡Hasta pronto! 👋\n")
        System.halt(0)
      _ ->
        IO.puts("⚠  Opción inválida. Intenta de nuevo.")
        loop(socios)
    end
  end

  defp mostrar_menu do
    IO.puts("\n#{@separador}")
    IO.puts("  MENÚ PRINCIPAL")
    IO.puts(@separador)
    IO.puts("  1. Crear socio")
    IO.puts("  2. Eliminar socio")
    IO.puts("  3. Inscribir socio en clase")
    IO.puts("  4. Desinscribir socio de clase")
    IO.puts("  5. Buscar socio por cédula")
    IO.puts("  6. Listar todos los socios")
    IO.puts("  7. Listar socios en una clase")
    IO.puts("  8. Ver clases de un socio")
    IO.puts("  9. Ver estadísticas")
    IO.puts("  0. Salir")
    IO.puts(@separador)
  end

  # ─── Opciones del menú ─────────────────────────────────────────────

  defp opcion_crear_socio(socios) do
    IO.puts("\n── Crear Socio ──")
    cedula = leer_linea("  Cédula    : ")
    nombre = leer_linea("  Nombre    : ")
    edad_str = leer_linea("  Edad      : ")

    edad =
      case Integer.parse(edad_str) do
        {n, ""} -> n
        _ -> -1
      end

    case Logica.agregar_socio(socios, cedula, nombre, edad) do
      {:ok, socios_nuevos} ->
        IO.puts("✓ Socio creado exitosamente.")
        socios_nuevos

      {:error, :cedula_duplicada} ->
        IO.puts("✗ Error: ya existe un socio con esa cédula.")
        socios

      {:error, :edad_invalida} ->
        IO.puts("✗ Error: la edad debe ser un número positivo.")
        socios

      {:error, razon} ->
        IO.puts("✗ Error: #{razon}")
        socios
    end
  end

  defp opcion_eliminar_socio(socios) do
    IO.puts("\n── Eliminar Socio ──")
    cedula = leer_linea("  Cédula del socio: ")

    case Logica.obtener_socio(socios, cedula) do
      {:ok, socio} ->
        confirmacion = leer_linea("  ¿Eliminar a #{socio.nombre}? (s/n): ")

        if String.downcase(String.trim(confirmacion)) == "s" do
          case Logica.eliminar_socio(socios, cedula) do
            {:ok, socios_nuevos} ->
              IO.puts("✓ Socio eliminado.")
              socios_nuevos

            {:error, razon} ->
              IO.puts("✗ Error: #{razon}")
              socios
          end
        else
          IO.puts("  Operación cancelada.")
          socios
        end

      {:error, :socio_no_encontrado} ->
        IO.puts("✗ No se encontró un socio con esa cédula.")
        socios
    end
  end

  defp opcion_inscribir_clase(socios) do
    IO.puts("\n── Inscribir en Clase ──")
    cedula = leer_linea("  Cédula del socio: ")
    clase  = leer_linea("  Nombre de la clase: ")

    case Logica.inscribir_clase(socios, cedula, clase) do
      {:ok, socios_nuevos} ->
        IO.puts("✓ Socio inscrito en \"#{clase}\".")
        socios_nuevos

      {:error, :ya_inscrito} ->
        IO.puts("✗ El socio ya está inscrito en esa clase.")
        socios

      {:error, :socio_no_encontrado} ->
        IO.puts("✗ No se encontró un socio con esa cédula.")
        socios

      {:error, :nombre_clase_invalido} ->
        IO.puts("✗ El nombre de la clase no puede estar vacío.")
        socios

      {:error, razon} ->
        IO.puts("✗ Error: #{razon}")
        socios
    end
  end

  defp opcion_desinscribir_clase(socios) do
    IO.puts("\n── Desinscribir de Clase ──")
    cedula = leer_linea("  Cédula del socio: ")
    clase  = leer_linea("  Nombre de la clase: ")

    case Logica.desinscribir_clase(socios, cedula, clase) do
      {:ok, socios_nuevos} ->
        IO.puts("✓ Socio desinscrito de \"#{clase}\".")
        socios_nuevos

      {:error, :no_inscrito} ->
        IO.puts("✗ El socio no está inscrito en esa clase.")
        socios

      {:error, :socio_no_encontrado} ->
        IO.puts("✗ No se encontró un socio con esa cédula.")
        socios

      {:error, razon} ->
        IO.puts("✗ Error: #{razon}")
        socios
    end
  end

  defp opcion_buscar_socio(socios) do
    IO.puts("\n── Buscar Socio ──")
    cedula = leer_linea("  Cédula: ")

    case Logica.obtener_socio(socios, cedula) do
      {:ok, socio} ->
        IO.puts("\n  #{@separador}")
        Socio.mostrar(socio)
        IO.puts("  #{@separador}")

      {:error, :socio_no_encontrado} ->
        IO.puts("✗ No se encontró un socio con esa cédula.")
    end

    socios
  end

  defp opcion_listar_socios(socios) do
    IO.puts("\n── Lista de Socios ──")

    case Logica.listar_socios(socios) do
      {:ok, []} ->
        IO.puts("  (No hay socios registrados)")

      {:ok, lista} ->
        IO.puts("  Total: #{length(lista)} socio(s)\n")

        lista
        |> Enum.sort_by(& &1.nombre)
        |> Enum.each(fn socio ->
          IO.puts("  #{@separador}")
          Socio.mostrar(socio)
        end)

        IO.puts("  #{@separador}")
    end

    socios
  end

  defp opcion_socios_en_clase(socios) do
    IO.puts("\n── Socios en una Clase ──")
    clase = leer_linea("  Nombre de la clase: ")

    case Logica.socios_en_clase(socios, clase) do
      {:ok, []} ->
        IO.puts("  No hay socios inscritos en \"#{clase}\".")

      {:ok, lista} ->
        IO.puts("  Socios inscritos en \"#{clase}\" (#{length(lista)}):\n")

        Enum.each(lista, fn socio ->
          IO.puts("    • #{socio.nombre} (cédula: #{socio.cedula})")
        end)
    end

    socios
  end

  defp opcion_clases_de_socio(socios) do
    IO.puts("\n── Clases de un Socio ──")
    cedula = leer_linea("  Cédula del socio: ")

    case Logica.clases_de_socio(socios, cedula) do
      {:ok, []} ->
        IO.puts("  El socio no está inscrito en ninguna clase.")

      {:ok, clases} ->
        IO.puts("  Clases inscritas (#{length(clases)}):")
        Enum.each(clases, fn clase -> IO.puts("    • #{clase}") end)

      {:error, :socio_no_encontrado} ->
        IO.puts("✗ No se encontró un socio con esa cédula.")
    end

    socios
  end

  defp opcion_estadisticas(socios) do
    IO.puts("\n── Estadísticas del Gimnasio ──")

    case Logica.obtener_estadisticas(socios) do
      {:ok, stats} ->
        IO.puts("  Total de socios         : #{stats.total_socios}")
        IO.puts("  Clases distintas        : #{stats.clases_distintas}")
        IO.puts("  Edad promedio           : #{stats.edad_promedio} años")
    end

    socios
  end

  # ─── Helpers ───────────────────────────────────────────────────────

  defp leer_linea(prompt) do
    IO.write(prompt)

    case IO.read(:line) do
      :eof   -> ""
      linea  -> String.trim(linea)
    end
  end
end
