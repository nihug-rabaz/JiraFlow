class JiraEpicHelper {
    hidden [JiraMetaApi] $Meta
    hidden [JiraConnectionConfig] $Cfg

    JiraEpicHelper([JiraMetaApi]$meta, [JiraConnectionConfig]$cfg) {
        $this.Meta = $meta
        $this.Cfg = $cfg
    }

    [string] ResolveEpicLinkFieldId() {
        if ($this.Cfg.EpicLinkFieldId) { return $this.Cfg.EpicLinkFieldId }
        $fields = $this.Meta.ListFields()
        foreach ($f in $fields) {
            if ($f.name -eq 'Epic Link' -or $f.schema.custom -eq 'com.pyxis.greenhopper.jira:gh-epic-link') {
                return $f.id
            }
        }
        throw "Epic Link field not found; set JIRA_EPIC_LINK_FIELD to the custom field id"
    }
}
