
namespace ClienteAPI.Models;
public class Cliente
{
    public int Id { get; set; }
    public string Matricula { get; set; }
    public string Nome { get; set; }
    public DateTime DataNascimento { get; set; }
    public string Nacionalidade { get; set; }
    public string Sexo { get; set; }
    public string EstadoCivil { get; set; }
    public string RG { get; set; }
    public string CPF { get; set; }
    public string Endereco { get; set; }
    public DateTime DataAdmissao { get; set; }
    public DateTime DataCadastro { get; set; } = DateTime.Now;

    public List<CargoOcupado> CargosOcupados { get; set; }
    public List<Dependente> Dependentes { get; set; }
}

// Models/CargoOcupado.cs
public class CargoOcupado
{
    public int Id { get; set; }
    public int ClienteId { get; set; }
    public Cliente Cliente { get; set; }
    public string Cargo { get; set; }
    public DateTime DataInicio { get; set; }
    public DateTime? DataFim { get; set; }
}

// Models/Dependente.cs
public class Dependente
{
    public int Id { get; set; }
    public int ClienteId { get; set; }
    public Cliente Cliente { get; set; }
    public string Nome { get; set; }
    public string Parentesco { get; set; }
    public DateTime DataNascimento { get; set; }
    public string CPF { get; set; }
}