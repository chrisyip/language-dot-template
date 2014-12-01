describe 'doT grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-dot-template')

    runs ->
      grammar = atom.grammars.grammarForScopeName('text.html.dot')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'text.html.dot'

  it 'parses expressions', ->
    {tokens} = grammar.tokenizeLine("{{name}}")

    expect(tokens[0]).toEqual value: '{{', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']
    expect(tokens[1]).toEqual value: 'name', scopes: ['text.html.dot', 'meta.tag.template.dot']
    expect(tokens[2]).toEqual value: '}}', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']

  it 'parses comments', ->
    {tokens} = grammar.tokenizeLine("{{!comment}}")

    expect(tokens[0]).toEqual value: '{{!', scopes: ['text.html.dot', 'comment.block.dot']
    expect(tokens[1]).toEqual value: 'comment', scopes: ['text.html.dot', 'comment.block.dot']
    expect(tokens[2]).toEqual value: '}}', scopes: ['text.html.dot', 'comment.block.dot']

  it 'parses block expression', ->
    {tokens} = grammar.tokenizeLine("{{#each people}}")

    expect(tokens[0]).toEqual value: '{{', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']
    expect(tokens[1]).toEqual value: '#', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot', 'punctuation.definition.block.begin.dot']
    expect(tokens[2]).toEqual value: 'each', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot', 'entity.name.function.dot']
    expect(tokens[3]).toEqual value: ' people', scopes: ['text.html.dot', 'meta.tag.template.dot']
    expect(tokens[4]).toEqual value: '}}', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']

    {tokens} = grammar.tokenizeLine("{{^repo}}")

    expect(tokens[0]).toEqual value: '{{', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']
    expect(tokens[1]).toEqual value: '^', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot', 'punctuation.definition.block.begin.dot']
    expect(tokens[2]).toEqual value: 'repo', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot', 'entity.name.function.dot']
    expect(tokens[3]).toEqual value: '}}', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']

    {tokens} = grammar.tokenizeLine("{{/if}}")

    expect(tokens[0]).toEqual value: '{{', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']
    expect(tokens[1]).toEqual value: '/', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot', 'punctuation.definition.block.end.dot']
    expect(tokens[2]).toEqual value: 'if', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot', 'entity.name.function.dot']
    expect(tokens[3]).toEqual value: '}}', scopes: ['text.html.dot', 'meta.tag.template.dot', 'entity.name.tag.dot']

  it 'parses unescaped expressions', ->
    {tokens} = grammar.tokenizeLine("{{{do not escape me}}}")

    expect(tokens[0]).toEqual value: '{{{', scopes: ['text.html.dot', 'meta.tag.template.raw.dot', 'entity.name.tag.dot']
    expect(tokens[1]).toEqual value: 'do not escape me', scopes: ['text.html.dot', 'meta.tag.template.raw.dot']
    expect(tokens[2]).toEqual value: '}}}', scopes: ['text.html.dot', 'meta.tag.template.raw.dot', 'entity.name.tag.dot']
