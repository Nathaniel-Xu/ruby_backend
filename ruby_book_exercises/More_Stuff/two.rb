#Nothing will be printed because block is not called.
def execute(&block)
  block
end

execute { puts "Hello from inside the execute method!" }