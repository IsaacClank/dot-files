set notes_root ~/.local/share/notes

function notes
  if not test -f $notes_root
    mkdir -p (dirname $notes_root)
  end

  switch $argv[1]
    case ""
      show $argv[1..]
    case "show"
      show $argv[2..]
    case "edit"
      edit $argv[2..]
    case "ed"
      edit $argv[2..]
    case "*"
      show $argv[1..]
  end
end

function show
  set note_name $argv[1]
  set VIEWER $PAGER

  if test -z $note_name
    $VIEWER (find $notes_root -type f | fzf)
    return;
  end

  set note_path $notes_root/$note_name.md

  if not test -f $note_path
    echo "Note does not exist"
    return
  else
    $VIEWER $note_path
  end
end

function edit
  set note_name $argv[1]

  if test -z $note_name
    $EDITOR (find $notes_root -type f | fzf)
  else
    $EDITOR $notes_root/$note_name.md
  end
end
