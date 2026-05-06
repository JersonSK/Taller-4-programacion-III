defmodule Gimnasio.Socio do
  @moduledoc """
  Define el struct Socio y sus validaciones.
  Cada socio tiene cédula, nombre, edad y lista de clases.
  """

  @enforce_keys [:cedula, :nombre, :edad]
  defstruct [:cedula, :nombre, :edad, clases: []]

  @doc """
  Crea un nuevo socio validando los datos de entrada.

  Retorna {:ok, %Socio{}} o {:error, motivo}
  """
  def nuevo(cedula, nombre, edad) do
    with :ok <- validar_cedula(cedula),
         :ok <- validar_nombre(nombre),
         :ok <- validar_edad(edad) do
      {:ok, %__MODULE__{cedula: cedula, nombre: nombre, edad: edad, clases: []}}
    end
  end

  @doc """
  Inscribe al socio en una clase, evitando duplicados.
  """
  def inscribir_clase(%__MODULE__{} = socio, clase) do
    clase = String.trim(clase)

    cond do
      String.length(clase) == 0 ->
        {:error, :nombre_clase_invalido}

      clase in socio.clases ->
        {:error, :ya_inscrito}

      true ->
        {:ok, %{socio | clases: socio.clases ++ [clase]}}
    end
  end

  @doc """
  Desinscribe al socio de una clase.
  """
  def desinscribir_clase(%__MODULE__{} = socio, clase) do
    if clase in socio.clases do
      {:ok, %{socio | clases: List.delete(socio.clases, clase)}}
    else
      {:error, :no_inscrito}
    end
  end

  @doc """
  Actualiza nombre y/o edad del socio.
  """
  def actualizar(%__MODULE__{} = socio, nombre, edad) do
    with :ok <- validar_nombre(nombre),
         :ok <- validar_edad(edad) do
      {:ok, %{socio | nombre: nombre, edad: edad}}
    end
  end

  # --- Validaciones privadas ---

  defp validar_cedula(cedula) when is_binary(cedula) do
    if String.length(String.trim(cedula)) > 0,
      do: :ok,
      else: {:error, :cedula_invalida}
  end
  defp validar_cedula(_), do: {:error, :cedula_invalida}

  defp validar_nombre(nombre) when is_binary(nombre) do
    if String.length(String.trim(nombre)) > 0,
      do: :ok,
      else: {:error, :nombre_invalido}
  end
  defp validar_nombre(_), do: {:error, :nombre_invalido}

  defp validar_edad(edad) when is_integer(edad) and edad > 0, do: :ok
  defp validar_edad(edad) when is_binary(edad) do
    case Integer.parse(edad) do
      {n, ""} when n > 0 -> :ok
      _ -> {:error, :edad_invalida}
    end
  end
  defp validar_edad(_), do: {:error, :edad_invalida}

  @doc """
  Muestra el socio de forma legible en consola.
  """
  def mostrar(%__MODULE__{} = socio) do
    clases_str = if socio.clases == [], do: "(ninguna)", else: Enum.join(socio.clases, ", ")
    IO.puts("  Cédula : #{socio.cedula}")
    IO.puts("  Nombre : #{socio.nombre}")
    IO.puts("  Edad   : #{socio.edad} años")
    IO.puts("  Clases : #{clases_str}")
  end
end
