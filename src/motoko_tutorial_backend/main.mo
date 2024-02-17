import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";

// ToDo Projesi

 
actor Assistant {
  
  type ToDo = {
    description: Text;
    completed: Bool;

  };

  //HashMap = Her işleme tc numarası atamak gibi 
  func natHash(n: Nat) : Hash.Hash {
    Text.hash(Nat.toText(n))
    
  };

  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);

  var nextId : Nat = 0;


  public query func getTodos() : async [ToDo] {
    Iter.toArray(todos.vals());

  };
  // ID ToDo ataması -sorgu ve tanımlama

  public query func addTodo(description: Text) : async Nat {
    let id = nextId;
    todos.put(id, {description = description; completed = false});
    nextId += 1;
    id
    
  };

  // update ataması
  public func completeTodo(id: Nat): async () {
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, {description; completed = true});
    }
  };


  public query func showTodos() : async Text {
    var output : Text = "\n____TO-Dos____\n";
    for (todo: ToDo in todos.vals()){
      output #= "\n" # todo.description;
      if(todo.completed) {output #= "OK"; };
    };
    output # "\n"

  };

  public func temizle() : async () {

    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
    func(_, todo) {if (todo.completed) null else ?todo});

  };

};

// canister : akıllı sözleşme