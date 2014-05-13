describe(".helloText", function(){
  When(function(){ this.result = helloText(); });
  Then(function(){ expect(this.result).toEqual("Hello, World!"); });
});
