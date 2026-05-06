defmodule Gimnasio.GestionArchivos do
  @moduledoc """
  Maneja la lectura y escritura del archivo socios.csv.

  Formato CSV:
    cedula,nombre,edad,clases
    123,Juan Pérez,30,Yoga;Pilates
    456,Ana García,25,CrossFit;Yoga
  """

  alias Gimnasio.Socio

  @archivo "socios.csv"
  @cabecera "cedula,nombre,edad,clases"

  @doc """
  Carga los socios desde el archivo CSV.
  Si el archivo no existe lo crea vacío y retorna {:ok, %{}}.
  """
  def cargar_socios do
    case File.read(@archivo) do
      {:ok, contenido} ->
        socios = parsear_csv(contenido)
        {:ok, socios}

      {:error, :enoent} ->
        case File.write(@archivo, @cabecera <> "\n") do
          :ok -> {:ok, %{}}
          {:error, razon} -> {:error, "No se pudo crear el archivo: #{razon}"}
        end

      {:error, razon} ->
        {:error, "Error al leer el archivo: #{razon}"}
    end
  end

  @doc """
  Guarda todos los socios en el archivo CSV.
  """
  def guardar_socios(socios) do
    lineas =
      socios
      |> Map.values()
      |> Enum.map(&serializar_socio/1)
      |> Enum.join("\n")

    contenido =
      if lineas == "",
        do: @cabecera <> "\n",
        else: @cabecera <> "\n" <> lineas <> "\n"

    case File.write(@archivo, contenido) do
      :ok -> {:ok, socios}
      {:error, razon} -> {:error, "Error al guardar: #{razon}"}
    end
  end

  # --- Funciones privadas ---

  defp parsear_csv(contenido) do
    contenido
    |> String.split("\n", trim: true)
    |> Enum.drop(1)  # Saltar cabecera
    |> Enum.reduce(%{}, fn linea, acc ->
      case parsear_linea(linea) do
        {:ok, socio} -> Map.put(acc, socio.cedula, socio)
        {:error, _}  -> acc  # Ignorar líneas malformadas
      end
    end)
  end

  defp parsear_linea(linea) do
    case String.split(linea, ",") do
      [cedula, nombre, edad_str | resto] ->
        clases_str = Enum.join(resto, ",")  # Por si el nombre tiene comas
        clases =
          clases_str
          |> String.trim()
          |> then(fn s -> if s == "", do: [], else: String.split(s, ";", trim: true) end)

        case Integer.parse(String.trim(edad_str)) do
          {edad, ""} ->
            socio = %Socio{
              cedula: String.trim(cedula),
              nombre: String.trim(nombre),
              edad: edad,
              clases: clases
            }
            {:ok, socio}

          _ ->
            {:error, :edad_invalida}
        end

      _ ->
        {:error, :formato_invalido}
    end
  end

  defp serializar_socio(%Socio{} = socio) do
    clases_str = Enum.join(socio.clases, ";")
    "#{socio.cedula},#{socio.nombre},#{socio.edad},#{clases_str}"
  end
end
