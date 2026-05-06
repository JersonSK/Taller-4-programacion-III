defmodule Gimnasio.Logica do
  @moduledoc """
  Lógica de negocio del gimnasio.
  Opera sobre un Map de socios: %{cedula => %Socio{}}
  Todas las funciones retornan {:ok, resultado} | {:error, motivo}
  """

  alias Gimnasio.{Socio, GestionArchivos}

  # ─── CRUD de socios ────────────────────────────────────────────────

  @doc "Agrega un nuevo socio al mapa. Falla si la cédula ya existe."
  def agregar_socio(socios, cedula, nombre, edad) do
    cedula = String.trim(cedula)

    if Map.has_key?(socios, cedula) do
      {:error, :cedula_duplicada}
    else
      with {:ok, socio} <- Socio.nuevo(cedula, nombre, edad) do
        socios = Map.put(socios, cedula, socio)
        guardar(socios)
      end
    end
  end

  @doc "Elimina un socio por cédula."
  def eliminar_socio(socios, cedula) do
    if Map.has_key?(socios, cedula) do
      socios = Map.delete(socios, cedula)
      guardar(socios)
    else
      {:error, :socio_no_encontrado}
    end
  end

  @doc "Actualiza nombre y edad de un socio existente."
  def actualizar_socio(socios, cedula, nombre, edad) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} ->
        with {:ok, socio_actualizado} <- Socio.actualizar(socio, nombre, edad) do
          socios = Map.put(socios, cedula, socio_actualizado)
          guardar(socios)
        end

      :error ->
        {:error, :socio_no_encontrado}
    end
  end

  # ─── Clases ────────────────────────────────────────────────────────

  @doc "Inscribe a un socio en una clase."
  def inscribir_clase(socios, cedula, clase) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} ->
        with {:ok, socio_actualizado} <- Socio.inscribir_clase(socio, clase) do
          socios = Map.put(socios, cedula, socio_actualizado)
          guardar(socios)
        end

      :error ->
        {:error, :socio_no_encontrado}
    end
  end

  @doc "Desinscribe a un socio de una clase."
  def desinscribir_clase(socios, cedula, clase) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} ->
        with {:ok, socio_actualizado} <- Socio.desinscribir_clase(socio, clase) do
          socios = Map.put(socios, cedula, socio_actualizado)
          guardar(socios)
        end

      :error ->
        {:error, :socio_no_encontrado}
    end
  end

  # ─── Consultas ─────────────────────────────────────────────────────

  @doc "Busca un socio por cédula."
  def obtener_socio(socios, cedula) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} -> {:ok, socio}
      :error -> {:error, :socio_no_encontrado}
    end
  end

  @doc "Retorna lista de todos los socios."
  def listar_socios(socios) do
    {:ok, Map.values(socios)}
  end

  @doc "Retorna socios inscritos en una clase específica."
  def socios_en_clase(socios, clase) do
    resultado =
      socios
      |> Map.values()
      |> Enum.filter(fn socio -> clase in socio.clases end)

    {:ok, resultado}
  end

  @doc "Retorna las clases de un socio dado su cédula."
  def clases_de_socio(socios, cedula) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} -> {:ok, socio.clases}
      :error -> {:error, :socio_no_encontrado}
    end
  end

  @doc "Estadísticas generales del gimnasio."
  def obtener_estadisticas(socios) do
    lista = Map.values(socios)
    total = length(lista)

    clases_unicas =
      lista
      |> Enum.flat_map(& &1.clases)
      |> Enum.uniq()
      |> length()

    edad_promedio =
      if total > 0 do
        suma = Enum.sum(Enum.map(lista, & &1.edad))
        Float.round(suma / total, 1)
      else
        0.0
      end

    {:ok, %{total_socios: total, clases_distintas: clases_unicas, edad_promedio: edad_promedio}}
  end

  # ─── Persistencia ──────────────────────────────────────────────────

  @doc "Carga socios desde el archivo CSV."
  def cargar do
    GestionArchivos.cargar_socios()
  end

  defp guardar(socios) do
    case GestionArchivos.guardar_socios(socios) do
      {:ok, _} -> {:ok, socios}
      {:error, razon} -> {:error, razon}
    end
  end
end
