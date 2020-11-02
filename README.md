# Identicon

PoC for generating GitHub style profile images using Elixir like this:

![Example Identicon Image](example.png)

## Usage

1. Install Elixir

   ```bash
   brew install elixir
   ```

2. Start the interactive Elixir shell:

   ```bash
   iex -S mix
   ```

3. Call the main method

   ```elixir
   Identicon.main('example')
   ```

The program will generate a PNG image under the `tmp` directory in this project.
