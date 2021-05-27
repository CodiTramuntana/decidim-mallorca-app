# frozen_string_literal: true

Deface::Override.new(virtual_path: +"layouts/decidim/_main_footer",
                     name: "add_custom_footer",
                     insert_before: ".main-footer",
                     text: "<%= render partial: 'layouts/decidim/custom_footer' %>",
                     original: "4acba79b4f172ee3abaeb8a2f5385440646a50a8")
