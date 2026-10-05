# anyforge.nvim -- roadmap

**Mode de travail**: projet d'apprentissage Lua/nvim. Le gros du code (logique
metier, modules ressources, picker, providers) est ecrit a la main. L'IA fait
uniquement le boilerplate rebarbatif (scaffolding de fichiers, config
lazy.nvim) et verifie/explique, ne code pas les modules a la place.

Plugin nvim maison pour gerer GitLab (issues, MR, pipelines, jobs, runners,
releases, notifications, milestones, branches, environments) sans quitter
l'editeur, avec un vrai rendu de diff (buffers natifs + treesitter), pas de
terminal ANSI brut.

## Pourquoi pas un outil existant

- **glab-tui** (rcieri/glab-tui, ref: https://github.com/rcieri/glab-tui):
  couvre large (issues, MR, pipelines, runners, releases, diff side-by-side,
  build traces en live), mais tourne en subprocess terminal. Le diff est
  colore par l'outil lui-meme (ANSI), jamais par treesitter/LSP nvim. Plafond
  de verre pour du highlighting reel sur `.vue`/`.ts`/etc.
- **gitlab.nvim** (harrisoncramer/gitlab.nvim): review MR correcte, diff via
  diffview.nvim (vrai highlighting), mais UI de selection basique (dressing.nvim
  au mieux), pas de picker fuzzy soigne, et scope limite a MR + commentaires
  (pas de runners/releases/notifications/milestones/environments).

Aucun des deux ne couvre a la fois "UI soignee et complete" et "diff avec vrai
highlighting". D'ou le plugin maison: reutilise `glab`/`gh` CLI comme backend
(auth deja geree, JSON natif) et diffview.nvim pour le rendu diff, construit
sa propre couche picker/UI par dessus.

## Direction visuelle

UI fortement inspiree de glab-tui: layout dense (liste + preview cote a
cote), navigation clavier ET souris, theme coherent avec le colorscheme nvim
actif (pas de palette fixe hardcodee), fuzzy search partout ou une liste
existe. Reference directe a garder sous les yeux pendant le dev de
`picker.lua`, screenshots sur https://terminaltrove.com/glab-tui/.

## Principe d'architecture

Un seul point qui touche le shell (`api.lua`), une couche provider qui
traduit chaque action en commande CLI (GitLab via `glab` aujourd'hui, GitHub
via `gh` demain, meme interface), une factory de picker generique reutilisee
par chaque ressource, un module par ressource. Zero duplication de logique
entre issues/MR/pipelines/etc: seule la config (quel provider, colonnes
affichees, actions) change d'un module a l'autre.

```
lua/thewawan/anyforge/
  init.lua          -- setup(), commandes top-level
  api.lua           -- run(cmd) -> json decode
  picker.lua        -- factory telescope generique (list + preview + actions)
  diff.lua          -- vue diff en buffers natifs (filetype reel, treesitter)
  log.lua           -- buffer scrollback append-only (trace des actions lancees)
  providers/
    gitlab.lua      -- implemente l'interface commune via `glab`
    github.lua      -- meme interface via `gh` (phase ulterieure)
  resources/
    mr.lua
    issues.lua
    pipelines.lua
    jobs.lua
    runners.lua
    releases.lua
    notifications.lua
    milestones.lua
    branches.lua
    environments.lua
```

**Pattern provider (adapter minimal, pas de classes/heritage):** l'adapter
fixe un CONTRAT de donnees normalisees en sortie. Chaque implementation
(`gitlab.lua`, `github.lua`) est responsable de mapper le JSON natif de son
CLI (`glab`/`gh`) vers ce contrat, elle appelle `api.run()` elle-meme et
retourne deja normalise. Un module ressource ne voit jamais la forme brute
GitLab ou GitHub, seulement le contrat.

```lua
-- providers/gitlab.lua (squelette, a coder)
local api = require("thewawan.anyforge.api")

local M = { mr = {}, issues = {} }

function M.mr.list(opts)
  local raw = api.run("glab mr list")
  -- mapper chaque entree raw vers le contrat MR (voir plus bas)
end

return M
```

**Contrat MR (decision gelee, format aligne sur les noms natifs GitLab,
`github.lua` doit s'y conformer en mappant ses propres champs dessus):**

```lua
{
  iid = 42,                 -- GitLab: iid tel quel. GitHub: mappe depuis `number`
  title = "...",
  state = "opened",         -- "opened" | "closed" | "merged" (valeurs GitLab natives)
  draft = false,
  author = { username = "..." },  -- GitHub: mappe `author.login` -> `username`
  source_branch = "...",    -- GitHub: mappe depuis `headRefName`
  target_branch = "...",    -- GitHub: mappe depuis `baseRefName`
  web_url = "https://...",  -- GitHub: mappe depuis `url`
  created_at = "2026-09-25T...",
  raw = { ... },             -- table brute d'origine, echappatoire pour un champ pas encore normalise
}
```

**Question encore ouverte, a trancher avant de coder `diff()`:** `provider.mr.diff(iid)`
retourne quoi exactement, texte diff brut en une string (parse cote
`diff.lua`), ou deja decoupe par fichier (`{ { path, patch }, ... }`) ? Le
choix change comment `diff.lua` s'en sert avec diffview.nvim.

Provider actif choisi par config explicite (`require("anyforge").setup({ provider = "gitlab" })`),
pas de detection automatique magique du remote a ce stade.

## Phases

Ordre choisi pour valider l'architecture tot (api + picker + diff) sur UNE
ressource avant de dupliquer le pattern sur les onze autres.

### Phase 0 -- fondations
- [x] Toggle terminal glab-tui brut (jetable, sert de reference/fallback)
- [ ] `api.lua`: wrapper shell -> JSON
- [ ] `providers/gitlab.lua`: interface commune (mr, issues, ...) implementee via `glab`
- [ ] `picker.lua`: factory telescope generique (list, preview, actions)
- [ ] `log.lua`: buffer scrollback, trace chaque commande lancee (visible,
      debug facile quand une action echoue)

### Phase 1 -- merge requests (valide tout le pattern)
- [ ] `resources/mr.lua`: liste, preview description/statut
- [ ] `diff.lua`: checkout + ouverture diffview.nvim sur la MR selectionnee
- [ ] Actions: checkout, approve, merge, ouvrir dans le navigateur

### Phase 2 -- issues (confirme que la factory generalise bien)
- [ ] `resources/issues.lua`: liste, filtre par label/assignee
- [ ] Actions: edit labels, assign, fermer/rouvrir
- [ ] Bulk edit (selection multiple telescope) si le besoin se confirme a l'usage

### Phase 3 -- pipelines et jobs
- [ ] `resources/pipelines.lua`: liste, statut, retry
- [ ] `resources/jobs.lua`: liste jobs d'un pipeline
- [ ] Stream logs d'un job dans le buffer `log.lua` (pas un vrai terminal
      interactif, un flux affiche au fur et a mesure)

### Phase 4 -- runners et releases
- [ ] `resources/runners.lua`: liste, statut (actif/pause)
- [ ] `resources/releases.lua`: liste, creation

### Phase 5 -- reste du perimetre (branches, environments, milestones, notifications)
- [ ] Un module par ressource, meme pattern que phases 1-2. A ce stade la
      factory picker doit deja tout couvrir sans changement.

## Non-buts (YAGNI, evite de construire avant besoin reel)

- Pas de vrai terminal interactif pour les logs de jobs (un scrollback qui
  affiche suffit, pas besoin d'input clavier dans un stream de logs)
- Pas de reimplementation de l'auth GitLab/GitHub (glab/gh CLI la gerent deja)
- Pas de picker custom si telescope + la factory couvrent le besoin
- Pas de theme/config exposee tant qu'un vrai besoin de personnalisation
  n'est pas apparu a l'usage
- Pas de detection automatique du provider (GitLab vs GitHub) tant que le
  besoin reel de multi-provider n'est pas confirme, config explicite suffit

## Dispositions open source (a prendre avant publication)

Plugin destine a etre publie a terme, checklist a traiter avant le premier
push public (pas urgent pendant le dev prive, mais a garder en tete des
maintenant pour eviter de tout reecrire apres coup):

- **Licence**: MIT, standard de fait dans l'ecosysteme nvim (compatible avec
  toutes les deps: telescope, plenary, diffview sont MIT/GPL-3.0 mais aucune
  n'est vendored ici, juste des dependances runtime)
- **Zero info perso hardcodee**: pas de chemin absolu type `/Users/erwan...`,
  pas d'email, pas de token, pas de nom de repo prive en dur dans le code ou
  les exemples de config
- **README installable**: instructions lazy.nvim/packer, liste des deps
  (`glab` CLI, telescope.nvim, diffview.nvim), section "Inspired by" citant
  glab-tui et gitlab.nvim
- **Pas de secrets dans l'historique git**: verifier avant le premier push
  public qu'aucun token/URL interne n'a ete commit pendant le dev prive
- **Nommage**: tranche, `anyforge.nvim`. Verifie a nouveau juste avant le
  premier push public que le nom reste libre sur GitHub (recherche web faite
  le 2026-09-25, rien trouve, mais un repo recent peut echapper a l'index)
- **CI legere**: `stylua` (formatting) + `luacheck` (lint) suffisent, pas
  besoin de suite de tests lourde tant que le plugin est petit

## Sources

- glab-tui: https://github.com/rcieri/glab-tui
- gitlab.nvim: https://github.com/harrisoncramer/gitlab.nvim
- diffview.nvim: https://github.com/sindrets/diffview.nvim

## Sources

- glab-tui: https://github.com/rcieri/glab-tui
- gitlab.nvim: https://github.com/harrisoncramer/gitlab.nvim
- diffview.nvim: https://github.com/sindrets/diffview.nvim
